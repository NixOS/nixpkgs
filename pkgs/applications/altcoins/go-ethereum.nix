{ stdenv, lib, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "go-ethereum-${version}";
  version = "1.7.0";
  goPackagePath = "github.com/ethereum/go-ethereum";

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "go-ethereum";
    rev = "v${version}";
    sha256 = "0ybjaiyrfb320rab6a5r9iiqvkrcd8b2qvixzx0kjmc4a7l1q5zh";
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
