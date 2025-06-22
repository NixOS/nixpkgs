{
  stdenv,
  lib,
  fetchgit,
  cctools,
  writeText,
  ninja,
  python3,
}:
let
  # Note: Please use the recommended version for Chromium stable, i.e. from
  # <nixpkgs>/pkgs/applications/networking/browsers/chromium/info.json
  rev = "85cc21e94af590a267c1c7a47020d9b420f8a033";
  revNum = "2233"; # git describe $rev --match initial-commit | cut -d- -f3
  version = "2025-04-28";
  sha256 = "sha256-+nKP2hBUKIqdNfDz1vGggXSdCuttOt0GwyGUQ3Z1ZHI=";

  revShort = builtins.substring 0 7 rev;
  lastCommitPosition = writeText "last_commit_position.h" ''
    #ifndef OUT_LAST_COMMIT_POSITION_H_
    #define OUT_LAST_COMMIT_POSITION_H_

    #define LAST_COMMIT_POSITION_NUM ${revNum}
    #define LAST_COMMIT_POSITION "${revNum} (${revShort})"

    #endif  // OUT_LAST_COMMIT_POSITION_H_
  '';

in
stdenv.mkDerivation {
  pname = "gn-unstable";
  inherit version;

  src = fetchgit {
    # Note: The TAR-Archives (+archive/${rev}.tar.gz) are not deterministic!
    url = "https://gn.googlesource.com/gn";
    inherit rev sha256;
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

  buildPhase = ''
    python build/gen.py --no-last-commit-position
    ln -s ${lastCommitPosition} out/last_commit_position.h
    ninja -j $NIX_BUILD_CORES -C out gn
  '';

  installPhase = ''
    install -vD out/gn "$out/bin/gn"
  '';

  setupHook = ./setup-hook.sh;

  meta = with lib; {
    description = "Meta-build system that generates build files for Ninja";
    mainProgram = "gn";
    homepage = "https://gn.googlesource.com/gn";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      stesie
      matthewbauer
    ];
  };
}
