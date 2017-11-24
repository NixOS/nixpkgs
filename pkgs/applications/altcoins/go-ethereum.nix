{ stdenv, lib, buildGoPackage, fetchFromGitHub, libobjc, IOKit }:

buildGoPackage rec {
  name = "go-ethereum-${version}";
  version = "1.7.3";
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
    sha256 = "1w6rbq2qpjyf2v9mr18yiv2af1h2sgyvgrdk4bd8ixgl3qcd5b11";
  };

  # Fix cyclic referencing on Darwin
  postInstall = stdenv.lib.optionalString (stdenv.isDarwin) ''
    for file in $bin/bin/*; do
      # Not all files are referencing $out/lib so consider this step non-critical
      install_name_tool -delete_rpath $out/lib $file || true
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://ethereum.github.io/go-ethereum/;
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
