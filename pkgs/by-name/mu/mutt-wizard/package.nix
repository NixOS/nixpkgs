{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mutt-wizard";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "LukeSmithxyz";
    repo = "mutt-wizard";
    rev = "v${version}";
    sha256 = "sha256-1/+awwoAqD8Xm3hULcbpeTaLOHVuYRA4PPr3cq5Gy20=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "System for automatically configuring mutt and isync";
    homepage = "https://github.com/LukeSmithxyz/mutt-wizard";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
}
