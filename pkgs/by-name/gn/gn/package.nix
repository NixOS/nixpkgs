{
  stdenv,
  lib,
  fetchgit,
  cctools,
  ninja,
  python3,

  # Note: Please use the recommended version for Chromium stable, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/info.json
  version ? "0-unstable-2025-05-21",
  rev ? "ebc8f16ca7b0d36a3e532ee90896f9eb48e5423b",
  hash ? "sha256-9SxC/nXBjr2EYVM3fchgGUxgaf6W3MJziLUO1HvlmSk=",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gn";
  inherit version;

  src = fetchgit {
    url = "https://gn.googlesource.com/gn";
    inherit rev hash;
    leaveDotGit = true;
    deepClone = true;
    postFetch = ''
      cd "$out"
      mkdir .nix-files
      git rev-parse --short HEAD > .nix-files/REV_SHORT
      git describe --match initial-commit | cut -d- -f3 > .nix-files/REV_NUM
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
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

  configurePhase = ''
    runHook preConfigure
    python build/gen.py --no-last-commit-position
    export revShort=`cat .nix-files/REV_SHORT`
    export revNum=`cat .nix-files/REV_NUM`
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
      marcin-serwin
    ];
  };
})
