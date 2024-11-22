{ lib, stdenv, fetchFromGitHub, coreutils, git, gnugrep, gnused, makeWrapper, inotify-tools }:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "0-unstable-2024-02-15";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "493b0155fb974b477b6ea623d6e41e13ddad8500";
    hash = "sha256-hsq+kpB+akjbFKBeHMsP8ibrtygEG2Yf2QW9vFFIano=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
    cp -a contrib/git-* $out/bin/
  '';

  wrapperPath = lib.makeBinPath ([
    coreutils
    git
    gnugrep
    gnused
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [ inotify-tools ]);

  postFixup = ''
    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : $wrap_path

    wrapProgram $out/bin/git-sync-on-inotify \
      --prefix PATH : $wrap_path
  '';

  meta = {
    description = "Script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}
