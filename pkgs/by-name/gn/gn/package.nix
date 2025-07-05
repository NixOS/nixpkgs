{
  stdenv,
  lib,
  fetchgit,
  cctools,
  ninja,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gn";
  version = "0-unstable-2025-04-28";
  revNum = 2233;
  revShort = builtins.substring 0 7 finalAttrs.src.rev;

  src = fetchgit {
    # Note: The TAR-Archives (+archive/${rev}.tar.gz) are not deterministic!
    url = "https://gn.googlesource.com/gn";
    # Note: Please use the recommended version for Chromium stable, i.e. from
    # <nixpkgs>/pkgs/applications/networking/browsers/chromium/info.json
    rev = "85cc21e94af590a267c1c7a47020d9b420f8a033";
    hash = "sha256-+nKP2hBUKIqdNfDz1vGggXSdCuttOt0GwyGUQ3Z1ZHI=";
  };

  nativeBuildInputs = [
    ninja
    python3
  ];
  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error";
  # Relax hardening as otherwise gn unstable 2024-06-06 and later fail with:
  # cc1plus: error: '-Wformat-security' ignored without '-Wformat' [-Werror=format-security]
  hardeningDisable = [ "format" ];

  # preConfigure = '''';
  configurePhase = ''
    runHook preConfigure
    python build/gen.py --no-last-commit-position
    cat > out/last_commit_position.h << EOF
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM $revNum
    #define LAST_COMMIT_POSITION "$revNum ($revShort)"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
    EOF
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    ninja -j $NIX_BUILD_CORES -C out gn
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -vD out/gn "$out/bin/gn"
    runHook postInstall
  '';

  setupHook = ./setup-hook.sh;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Meta-build system that generates build files for Ninja";
    mainProgram = "gn";
    homepage = "https://gn.googlesource.com/gn";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      stesie
      matthewbauer
      primeos
      marcin-serwin
    ];
  };
})
