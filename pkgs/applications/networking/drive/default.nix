{ lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "drive-${version}";
  version = "0.3.8.1";

  goPackagePath = "github.com/odeke-em/drive";
  subPackages = [ "cmd/drive" ];

  src = fetchFromGitHub {
    owner = "odeke-em";
    repo = "drive";
    rev = "v${version}";
    sha256 = "1b9cgc148rg5irg4jas10zv9i2km75x1zin25hld340dmpjcpi82";
  };

  goDeps = ./deps.nix;

  meta = with lib; {
    homepage = https://github.com/odeke-em/drive;
    description = "Google Drive client for the commandline";
    license = licenses.asl20;
    platforms = platforms.unix;
  };
}
