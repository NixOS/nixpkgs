{
  callPackage,
  fetchFromGitHub,
}:

callPackage ../generic.nix rec {
  pname = "too-cruel-pixel-dungeon";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "juh9870";
    repo = "TooCruelPixelDungeon";
    tag = "v${version}";
    hash = "sha256-eAUbxt5tAcjM/JBg+Nm4Gjbz9/hFaZTVmX8RwfQ2IMc=";
  };

  patches = null;

  postPatch = ''
    sed -i '/MaxPermSize/d' gradle.properties
  '';

  desktopName = "Too Cruel Pixel Dungeon";

  meta = {
    homepage = "https://github.com/juh9870/TooCruelPixelDungeon";
    downloadPage = "https://github.com/juh9870/TooCruelPixelDungeon/releases";
    description = "Fork of the Shattered Pixel Dungeon roguelike with more cruel challenges";
  };
}
