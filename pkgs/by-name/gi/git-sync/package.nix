{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  git,
  gnugrep,
  gnused,
  makeWrapper,
  inotify-tools,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "0-unstable-2024-11-30";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "7242291edf543ecc1bb9de8f47086bb69a5cb9f7";
    hash = "sha256-t1NVgp+ELmTMK0N1fFFJCoKQd8mSYSMAIDG9+kNs3Ok=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
    cp -a contrib/git-* $out/bin/
  '';

  wrapperPath = lib.makeBinPath (
    [
      coreutils
      git
      gnugrep
      gnused
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]
  );

  postFixup = ''
    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : $wrap_path

    wrapProgram $out/bin/git-sync-on-inotify \
      --prefix PATH : $wrap_path
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}
