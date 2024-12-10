{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  perl,
  makeWrapper,
}:

with lib;

stdenv.mkDerivation rec {
  pname = "git-octopus";
  version = "1.4";

  installFlags = [ "prefix=$(out)" ];

  nativeBuildInputs = [ makeWrapper ];

  # perl provides shasum
  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${
        makeBinPath [
          git
          perl
        ]
      }
    done
  '';

  src = fetchFromGitHub {
    owner = "lesfurets";
    repo = "git-octopus";
    rev = "v${version}";
    sha256 = "14p61xk7jankp6gc26xciag9fnvm7r9vcbhclcy23f4ghf4q4sj1";
  };

  meta = {
    homepage = "https://github.com/lesfurets/git-octopus";
    description = "The continuous merge workflow";
    license = licenses.lgpl3;
    platforms = platforms.unix;
    maintainers = [ maintainers.mic92 ];
  };
}
