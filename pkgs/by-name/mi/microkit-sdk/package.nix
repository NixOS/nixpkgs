{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  symlinkJoin,
  rustPlatform,
  rustc,
  cargo,
  pkgsCross,
  python312,
  cmake,
  ninja,
  dtc,
  libxml2,
  qemu,
  pandoc,
  texliveSmall,
  makeWrapper,
  nukeReferences,

  # Empty lists select all upstream boards/configurations.
  boards ? [ ],
  configs ? [ ],
}:

let
  # seL4 revision from the manifest at the time of the Microkit release:
  # https://github.com/seL4/microkit-manifest/blob/c26cbe4e0c2ac60db925fb28b8cf9146f261bdcd/main.xml
  sel4Src = fetchFromGitHub {
    owner = "seL4";
    repo = "seL4";
    rev = "6e7c3b733d296cfd88d5fbf635c96e447a882374";
    hash = "sha256-j2OSvxU95t+4wXoUiv4WC49b68ibq4nY2ICSo/33RWg=";
  };

  # The bare-metal initialiser needs the Rust sources to build core and alloc.
  sysroot = symlinkJoin {
    name = "microkit-rust-sysroot";
    paths = [ rustc.unwrapped ];
    postBuild = ''
      mkdir -p "$out/lib/rustlib/src/rust"
      ln -s ${rustPlatform.rustLibSrc} "$out/lib/rustlib/src/rust/library"
    '';
  };

  python = python312.withPackages (
    ps: with ps; [
      ply
      jinja2
      pyaml
      lxml
      pyfdt
      setuptools
      jsonschema
      autopep8
    ]
  );

  tex = texliveSmall.withPackages (
    ps: with ps; [
      fancyvrb
      parskip
      titlesec
      enumitem
      sfmath
      roboto
      fontaxes
      isodate
      substr
      tcolorbox
      environ
      pdfcol
    ]
  );

  crossCompilers = {
    aarch64 = pkgsCross.aarch64-embedded.stdenv.cc;
    riscv64 = pkgsCross.riscv64-embedded.stdenv.cc;
    x86_64 = pkgsCross.x86_64-embedded.stdenv.cc;
  };

  sdkFlags = [
    "--sel4=seL4"
    "--skip-tar"
    "--tool-target-triple=${stdenv.hostPlatform.rust.rustcTarget}"
  ]
  ++ lib.mapAttrsToList (
    arch: cc: "--gcc-toolchain-prefix-${arch}=${lib.removeSuffix "-" cc.targetPrefix}"
  ) crossCompilers
  ++ lib.optional (boards != [ ]) "--boards=${lib.concatStringsSep "," boards}"
  ++ lib.optional (configs != [ ]) "--configs=${lib.concatStringsSep "," configs}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "microkit-sdk";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "seL4";
    repo = "microkit";
    tag = finalAttrs.version;
    hash = "sha256-fBA6iyHMeq7usQ1SoqmZh8eHrKFAEYa1Yzr5PlaGWQ8=";
  };

  patches = [
    # Support the PLIC device tree node name used by recent QEMU versions.
    (fetchpatch {
      url = "https://github.com/seL4/seL4/commit/c6ce4d2a0c334cc9365b2cc41ff0126d75c0ea3c.patch";
      stripLen = 1;
      extraPrefix = "seL4/";
      hash = "sha256-yOuPdR/JRLzusxanR9B0IkeB00yRtFk/B0zrtRxD4M8=";
    })
  ];

  # Account for upstream CMake indentation changes since the pinned revision.
  patchFlags = [
    "-p1"
    "-l"
  ];

  # out: complete SDK, doc: manual.
  outputs = [
    "out"
    "doc"
  ];

  cargoDeps = symlinkJoin {
    name = "${finalAttrs.pname}-${finalAttrs.version}-cargo-deps";
    paths = [
      (rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-tA/jFH0O/lroAjhihp58nNfsWTClJxTnkxJydKl9jDA=";
      })
    ];
    # Include the dependencies needed by -Z build-std for the initialiser.
    postBuild = ''
      cp -rsn ${rustPlatform.rustVendorSrc}/* "$out/source-registry-0/"
    '';
  };

  nativeBuildInputs = [
    (rustc.override { inherit sysroot; })
    cargo
    rustc.llvmPackages.lld
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    python
    cmake
    ninja
    dtc
    libxml2
    qemu
    pandoc
    tex
    makeWrapper
    nukeReferences
  ]
  ++ lib.concatMap (cc: [
    cc.cc
    cc.bintools.bintools
  ]) (lib.attrValues crossCompilers);

  __structuredAttrs = true;
  strictDeps = true;
  dontUseCmakeConfigure = true;
  # Preserve DWARF and the ELF symbols used by the image builder.
  dontStrip = true;
  dontPatchELF = true;

  # Keep Rust source paths from retaining the host toolchain.
  env."CARGO_TARGET_${stdenv.hostPlatform.rust.cargoEnvVarTarget}_RUSTFLAGS" =
    "--remap-path-prefix=${sysroot}=/rustc";

  prePatch = ''
    cp -r ${sel4Src} seL4
    chmod -R u+w seL4
  '';

  postPatch = ''
    patchShebangs seL4

    substituteInPlace build_sdk.py \
      --replace-fail '-p initialiser' '-p initialiser -Z build-std=core,alloc'
  '';

  buildPhase = ''
    runHook preBuild

    python3 build_sdk.py ${lib.escapeShellArgs sdkFlags}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    sdk="release/microkit-sdk-${finalAttrs.version}"
    mkdir -p "$out/bin" "$out/lib"

    mv "$sdk/doc" "$doc"
    mv "$sdk" "$out/lib/microkit"

    makeWrapper "$out/lib/microkit/bin/microkit" "$out/bin/microkit" \
      --set-default MICROKIT_SDK "$out/lib/microkit"

    runHook postInstall
  '';

  postInstall = ''
    # Target binaries do not depend on the host's Nix store.
    nuke-refs "$out"/lib/microkit/board/*/*/{elf/*.elf,lib/*.a}
  '';

  passthru = { inherit sel4Src; };

  meta = {
    description = "SDK for building systems on the seL4 Microkit";
    homepage = "https://docs.sel4.systems/projects/microkit/";
    changelog = "https://docs.sel4.systems/releases/microkit/${finalAttrs.version}";
    maintainers = [ lib.maintainers.r4v3n6101 ];
    license = with lib.licenses; [
      bsd2
      gpl2Only
      cc-by-sa-40
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "microkit";
    outputsToInstall = [ "out" ];
  };
})
