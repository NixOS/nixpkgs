{ lib, stdenv, fetchFromGitHub, coreutils, git, gnugrep, gnused, makeWrapper, inotify-tools }:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "unstable-2022-03-20";

  src = fetchFromGitHub {
    owner = "simonthum";
    repo = "git-sync";
    rev = "8466b77a38b3d5e8b4ed9e3cb1b635e475eeb415";
    sha256 = "sha256-8rCwpmHV6wgFCLzPJOKzwN5mG8uD5KIlGFwcgQD+SK4=";
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
  ] ++ lib.optionals stdenv.isLinux [ inotify-tools ]);

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
