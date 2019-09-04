{ stdenv, buildGoPackage, fetchFromGitHub, libobjc, IOKit }:

buildGoPackage rec {
  pname = "go-ethereum";
  version = "1.9.3";

  goPackagePath = "github.com/ethereum/go-ethereum";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lv6gxp34j26hqazcvyr4c7rsl1vljm6cfzkcmlapsjdgym505bg";
  };

  meta = with stdenv.lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ adisbladis asymmetric lionello xrelkd ];
  };
}
