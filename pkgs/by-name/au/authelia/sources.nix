{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.26";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-CFgv7H8no8Z4gYXheEKPyi8C7FGRC77kNqGnIjra3bA=";
  };
  vendorHash = "sha256-Bi3cAkcVP1ZWFBuy0RfpqW7yqyV5DxSsa6gmtfLgxEA=";
  pnpmDepsHash = "sha256-UpgS+6Wj88WyNE4JT9z0eSxYxKANWTfwL0+2xTlcWDQ=";
}
