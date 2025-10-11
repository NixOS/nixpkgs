{
  lib,
  stdenv,
  replaceVars,
  fetchFromGitHub,
  python3Packages,
  makePkgconfigItem,
  copyPkgconfigItems,
  ninja,
  testers,
  # Build options
  enableLto ? false,
  enableAsserts ? false,
  enableStats ? false,
  enableOverride ? true,
  enableHeaps ? true,
  enableValidation ? false,
  buildConfig ? "release",
}:
let
  inherit (stdenv.hostPlatform) extensions;

  # https://github.com/mjansson/rpmalloc/blob/6b34d956911bb778ec6b99e4dbff9e956c5dc467/build/ninja/platform.py#L8
  platforms = {
    "linux" = "linux";
    "darwin" = "macos";
    "freebsd" = "bsd";
    "netbsd" = "bsd";
    "openbsd" = "bsd";
    "win32" = "windows";
  };
  # https://github.com/mjansson/rpmalloc/blob/6b34d956911bb778ec6b99e4dbff9e956c5dc467/build/ninja/toolchain.py#L30
  arch = {
    "x64" = "x86-64";
    "x86" = "x86";
    "arm64" = "arm64";
    "aarch64" = "arm64";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "rpmalloc";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "mjansson";
    repo = "rpmalloc";
    tag = finalAttrs.version;
    hash = "sha256-dE6shh2F3a+pu510Vw9icQvk2aAoPWYCtrIlT08fF3A=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  nativeBuildInputs = [
    # Using withPackages doesn't work because withPackages doesn't splice correctly
    python3Packages.python
    python3Packages.standard-pipes
    ninja
    copyPkgconfigItems
  ];

  env = {
    ENABLE_VALIDATE_ARGS = enableValidation;
    ENABLE_STATISTICS = enableStats;
    ENABLE_ASSERTS = enableAsserts;
    ENABLE_OVERRIDE = enableOverride;
    RPMALLOC_FIRST_CLASS_HEAPS = enableHeaps;
  };

  configFlags = [
    "--toolchain"
    (
      if stdenv.cc.isGNU then
        "gcc"
      else if stdenv.cc.isClang then
        "clang"
      else
        throw "unsupported compiler"
    )
    "--arch"
    arch.${stdenv.hostPlatform.node.arch}
    "--target"
    platforms.${stdenv.hostPlatform.node.platform}
    "--config"
    buildConfig
  ]
  ++ lib.optionals enableLto [
    "--lto"
  ]
  ++ lib.optionals finalAttrs.doCheck [
    "--monolithic"
  ];

  doCheck = false;

  configurePhase = ''
    runHook preConfigure

    echo "Configuring with flags: ''${configFlags[@]}"

    python3 configure.py "''${configFlags[@]}"

    runHook postConfigure
  '';

  # The binaries are placed in paths with hashes so just
  # use find to find them in check and install.
  checkPhase = ''
    runHook preCheck

    find build/ninja -type f -executable -not -name '*.*' -exec {} \;

    runHook postCheck
  '';

  pkgconfigItems =
    let
      template = {
        version = finalAttrs.version;
        url = finalAttrs.meta.homepage;
        cflags = [ "-I@out@/include/rpmalloc" ];
      };
    in
    [
      (makePkgconfigItem (
        template
        // {
          name = "rpmalloc";
          libs = [
            "-L@out@/lib"
            "-lrpmalloc"
          ];
        }
      ))
      (makePkgconfigItem (
        template
        // {
          name = "rpmallocwrap";
          libs = [
            "-L@out@/lib"
            "-lrpmallocwrap"
          ];
        }
      ))
    ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib"
    find build/ninja -type f -name '*${extensions.library}' -exec cp {} "$out/lib" \;

    mkdir -p "$out/include/rpmalloc"
    cp rpmalloc/*.h "$out/include/rpmalloc"

    runHook postInstall
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    description = "lock free thread caching 16-byte aligned memory allocator";
    homepage = "https://github.com/mjansson/rpmalloc";
    changelog = "https://github.com/mjansson/rpmalloc/releases/tag/${finalAttrs.version}";
    pkgConfigModules = [
      "rpmalloc"
      "rpmallocwrap"
    ];
    license = with lib.licenses; [
      bsd0 # or
      unlicense
    ];
    maintainers = [ lib.maintainers.RossSmyth ];
  };
})
