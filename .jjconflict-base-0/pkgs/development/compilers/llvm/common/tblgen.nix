{
  cmake,
  devExtraCmakeFlags ? [ ],
  lib,
  llvm_meta,
  monorepoSrc ? null,
  ninja,
  patches ? [ ],
  python3,
  release_version,
  runCommand,
  src ? null,
  stdenv,
  version,
  clangPatches,
}:

let
  # This is a synthetic package which is not an official part of the llvm-project.
  # See https://github.com/NixOS/nixpkgs/pull/362384 for discussion.
  #
  # LLVM has tools that run at build time. In native builds, these are
  # built as a part of the usual build, but in cross builds they need to
  # come from buildPackages.
  #
  # In many scenarios this is a small problem because LLVM from
  # buildPackages is already available as a build; but if cross building a
  # version of LLVM which is not available (e.g. a new git commit of LLVM)
  # this results in two builds of LLVM and clang, one native and one for the
  # cross.
  #
  # Full builds of LLVM are expensive; and unnecessary in this scenario. We
  # don't need a native LLVM, only a native copy of the tools which run at
  # build time. This is only tablegen and related tooling, which are cheap
  # to build.
  pname = "llvm-tblgen";

  src' =
    if monorepoSrc != null then
      runCommand "${pname}-src-${version}" { } (
        ''
          mkdir -p "$out"
        ''
        + lib.optionalString (lib.versionAtLeast release_version "14") ''
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/third-party "$out"
        ''
        + ''
          cp -r ${monorepoSrc}/llvm "$out"
          cp -r ${monorepoSrc}/clang "$out"
          cp -r ${monorepoSrc}/clang-tools-extra "$out"
          cp -r ${monorepoSrc}/mlir "$out"
        ''
      )
    else
      src;

  self = stdenv.mkDerivation (finalAttrs: rec {
    inherit pname version patches;

    src = src';
    sourceRoot = "${src.name}/llvm";

    postPatch = ''
      (
        cd ../clang
        chmod u+rwX -R .
        for p in ${toString clangPatches}
        do
          patch -p1 < $p
        done
      )
    '';

    nativeBuildInputs = [
      cmake
      ninja
      python3
    ];

    cmakeFlags = [
      # Projects with tablegen-like tools.
      "-DLLVM_ENABLE_PROJECTS=${
        lib.concatStringsSep ";" (
          [
            "llvm"
            "clang"
            "clang-tools-extra"
          ]
          ++ lib.optionals (lib.versionAtLeast release_version "16") [
            "mlir"
          ]
        )
      }"
    ] ++ devExtraCmakeFlags;

    # List of tablegen targets.
    ninjaFlags =
      [
        "clang-tblgen"
        "llvm-tblgen"
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "15") [
        "clang-tidy-confusable-chars-gen"
      ]
      ++ lib.optionals (lib.versionAtLeast release_version "16") [
        "mlir-tblgen"
      ]
      ++
        lib.optionals ((lib.versionAtLeast release_version "15") && (lib.versionOlder release_version "20"))
          [
            "clang-pseudo-gen" # Removed in LLVM 20 @ ed8f78827895050442f544edef2933a60d4a7935.
          ];

    installPhase = ''
      mkdir -p $out
      cp -ar bin $out/bin
    '';
  });
in
self
