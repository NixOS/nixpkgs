{
  lib,
  stdenv,
  fetchFromGitLab,
  flac,
}:

stdenv.mkDerivation rec {
  version = "3.0.10+git20130108.4ca41f4-1";
  pname = "shntool";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "shntool";
    rev = "debian/${version}";
    sha256 = "sha256-Qn4LwVx34EhypiZDIxuveNhePigkuiICn1nBukoQf5Y=";
  };

  buildInputs = [ flac ];

  prePatch = ''
    patches=$(grep -v '#' ./debian/patches/series | while read patch; do echo "./debian/patches/$patch"; done | tr '\n' ' ')
  '';

  meta = {
    description = "Multi-purpose WAVE data processing and reporting utility";
    homepage = "https://packages.qa.debian.org/s/shntool.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ jcumming ];
  };
}
