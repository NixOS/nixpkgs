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

stdenv.mkDerivation (finalAttrs: {
  pname = "git-quick-stats";
  version = "2.11.0";

  src = fetchFromGitHub {
    repo = "git-quick-stats";
    owner = "arzzen";
    rev = finalAttrs.version;
    sha256 = "sha256-QWWIRhQ7OYtNoaApb+6B80NASngsjcZL7whpQF2Lpus=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installFlags = [
    "PREFIX=${placeholder "out"}"
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

  meta = {
    homepage = "https://github.com/arzzen/git-quick-stats";
    description = "Simple and efficient way to access various statistics in git repository";
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.kmein ];
    license = lib.licenses.mit;
    mainProgram = "git-quick-stats";
  };
})
