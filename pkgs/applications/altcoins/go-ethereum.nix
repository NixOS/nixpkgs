{ stdenv, buildGoPackage, fetchFromGitHub, libobjc, IOKit }:

buildGoPackage rec {
  name = "go-ethereum-${version}";
  version = "1.8.21";
  goPackagePath = "github.com/ethereum/go-ethereum";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    sha256 = "1p4qfxa90l26s9q4hddyb93gdf7vb0sb46z9n26ijiqlxdq3z7v2";
  };

  meta = with stdenv.lib; {
    homepage = https://ethereum.github.io/go-ethereum/;
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = [ maintainers.adisbladis maintainers.lionello ];
  };
}
