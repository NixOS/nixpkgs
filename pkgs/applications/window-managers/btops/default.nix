{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "btops";
  version = "0.1.0";

  goPackagePath = "github.com/cmschuetz/btops";

  src = fetchFromGitHub {
    owner = "cmschuetz";
    repo = "btops";
    rev = version;
    sha256 = "sha256-eE28PGfpmmhcyeSy3PICebAs+cHAZXPxT+S/4+9ukcY=";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    description = "bspwm desktop management that supports dymanic appending, removing, and renaming";
    homepage = "https://github.com/cmschuetz/btops";
    maintainers = with maintainers; [ mnacamura ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
