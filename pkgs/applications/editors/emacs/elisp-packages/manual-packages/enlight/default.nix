{
  lib,
  compat,
  fetchFromGitHub,
  melpaBuild,
}:

melpaBuild {
  pname = "enlight";
  version = "20240601.1150";

  src = fetchFromGitHub {
    owner = "ichernyshovvv";
    repo = "enlight";
    rev = "76753736da1777c8f9ebbeb08beec15b330a5878";
    hash = "sha256-Ccfv4Ud5B4L4FfIOI2PDKikV9x8x3a7VeHYDyLV7t4g=";
  };

  packageRequires = [ compat ];

  meta = {
    homepage = "https://github.com/ichernyshovvv/enlight";
    description = "Highly customizable startup screen for Emacs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
