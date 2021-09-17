{ lib, stdenv, fetchFromGitHub, coreutils, git, gnugrep, gnused, makeWrapper, inotify-tools }:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "unstable-2021-07-14";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "7d3d34bf3ee2483fba00948f5b97f964b849a590";
    sha256 = "sha256-PuYREW5NBkYF1tlcLTbOI8570nvHn5ifN8OIInfNNxI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
  '';

  wrapperPath = with lib; makeBinPath [
    inotify-tools
    coreutils
    git
    gnugrep
    gnused
  ];

  postFixup = ''
    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : $wrap_path

    wrapProgram $out/bin/git-sync-on-inotify \
      --prefix PATH : $wrap_path
  '';

  meta = {
    description = "A script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}
