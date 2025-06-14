{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  coreutils,
  gawk,
  git,
  gnugrep,
  ncurses,
  util-linux,
}:

stdenv.mkDerivation rec {
  pname = "git-quick-stats";
  version = "2.6.0";

  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = version;
    sha256 = "sha256-bD3LBsvMcsnDC0tt+91beKaSkQoXu4DurM7fTCjjr/g=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${builtins.placeholder "out"}"
  ];

  postInstall =
    let
      path = lib.makeBinPath [
        coreutils
        gawk
        git
        gnugrep
        ncurses
        util-linux
      ];
    in
    ''
      wrapProgram $out/bin/git-quick-stats --suffix PATH : ${path}
    '';

  meta = with lib; {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "Simple and efficient way to access various statistics in git repository";
    platforms = platforms.all;
    maintainers = [ maintainers.kmein ];
    license = licenses.mit;
    mainProgram = "git-quick-stats";
  };
}
