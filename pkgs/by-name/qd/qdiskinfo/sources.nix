{ fetchzip }:
{
  aoi = fetchzip {
    url = "https://pilotfiber.dl.sourceforge.net/project/crystaldiskinfo/9.3.2/CrystalDiskInfo9_3_2Aoi.zip?viasf=1#cdi.zip";
    hash = "sha256-yldOX/aQYK1Fsd+BpD0SdcyfnHxtwB5rmZHU1nY7Ov8=";
    stripRoot = false;
  };
  kureikei = fetchzip {
    url = "https://pilotfiber.dl.sourceforge.net/project/crystaldiskinfo/9.3.2/CrystalDiskInfo9_3_2KureiKei.zip?viasf=1#cdi.zip";
    hash = "sha256-mzV3wHKczsh5NOsUxA3kGYSBZyVNJZUWkZdjiJA8+Po=";
    stripRoot = false;
  };
  shizuku = fetchzip {
    url = "https://pilotfiber.dl.sourceforge.net/project/crystaldiskinfo/9.3.2/CrystalDiskInfo9_3_2Shizuku.zip?viasf=1#cdi.zip";
    hash = "sha256-4dVeOHXWUVjfSssJKpcSBQ7OTMaYmgF15M4ROD3SBDA=";
    stripRoot = false;
  };
}
