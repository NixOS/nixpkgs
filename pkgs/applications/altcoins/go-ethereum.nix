{ stdenv, lib, buildGoPackage, fetchFromGitHub, libobjc, IOKit }:

buildGoPackage rec {
  name = "go-ethereum-${version}";
  version = "1.8.3";
  goPackagePath = "github.com/ethereum/go-ethereum";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  # Only install binaries in $out, source is not interesting and takes ~50M
  outputs = [ "out" ];
  preFixup = ''
    export bin="''${out}"
  '';
  installPhase = ''
    mkdir -p $out/bin $out
    dir="$NIX_BUILD_TOP/go/bin"
    [ -e "$dir" ] && cp -r $dir $out
  '';

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    sha256 = "1vdrf3fi4arr6aivyp5myj4jy7apqbiqa6brr3jplmc07q1yijnf";
  };

  meta = with stdenv.lib; {
    homepage = https://ethereum.github.io/go-ethereum/;
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = [ maintainers.adisbladis ];
  };
}
