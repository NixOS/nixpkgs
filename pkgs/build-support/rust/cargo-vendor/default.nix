{ callPackage, fetchFromGitHub }:

((callPackage ./cargo-vendor.nix {}).cargo_vendor_0_1_16 {}).overrideAttrs (attrs: {
  src = fetchFromGitHub {
    owner = "alexcrichton";
    repo = "cargo-vendor";
    rev = "53d0a81cd32cdaa71bf07ebfa021e2f6e0caaa39";
    sha256 = "1cmp0slsmaz3vqz3v8xv19x9cqwpvgk4sgvxm37clx25pdkr7wi3";
  };
})
