{ stdenv, buildGoPackage, fetchFromGitHub, libobjc, IOKit, fetchpatch }:

buildGoPackage rec {
  pname = "go-ethereum";
  version = "1.8.27";

  goPackagePath = "github.com/ethereum/go-ethereum";

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    stdenv.lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  # Fixes Cgo related build failures (see https://github.com/NixOS/nixpkgs/issues/25959 )
  hardeningDisable = [ "fortify" ];

  # Apply ethereum/go-ethereum#19183 to fix the aarch64 build failure.
  #
  # TODO Remove this patch when upstream (https://github.com/ethereum/go-ethereum)
  # fix this problem in the future release.
  patches = [
    (fetchpatch {
      url = "https://github.com/ethereum/go-ethereum/commit/39bd2609.patch";
      sha256 = "1a362hzvcjk505hicv25kziy3c6s5an4j7rk4jibcxwgvygb3mz5";
    })
 ];

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "1640y7lqy7bvjjgx6wp0cnbw632ls5fj4ixclr819lfz4p5dfhx1";
  };

  meta = with stdenv.lib; {
    homepage = https://ethereum.github.io/go-ethereum/;
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3 gpl3 ];
    maintainers = with maintainers; [ adisbladis asymmetric lionello ];
  };
}
