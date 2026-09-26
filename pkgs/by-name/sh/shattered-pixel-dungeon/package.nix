{
  callPackage,
  fetchFromGitHub,
  nixosTests,
}:

callPackage ./generic.nix rec {
  pname = "shattered-pixel-dungeon";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "00-Evan";
    repo = "shattered-pixel-dungeon";
    tag = "v${version}";
    hash = "sha256-/hqnFY7HEK8yQz1hVMyh/2CnO1zIOyOLwTDUM6jkSKk=";
  };

  patches = [ ];

  depsPath = ./deps.json;

  passthru.tests = {
    shattered-pixel-dungeon-starts = nixosTests.shattered-pixel-dungeon;
  };

  desktopName = "Shattered Pixel Dungeon";

  meta = {
    homepage = "https://shatteredpixel.com/";
    downloadPage = "https://github.com/00-Evan/shattered-pixel-dungeon/releases";
    description = "Traditional roguelike game with pixel-art graphics and simple interface";
  };
}
