{ fetchFromGitHub }:
rec {
  pname = "authelia";
  version = "4.39.27";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = "authelia";
    rev = "v${version}";
    hash = "sha256-lN8KH3JvL1s1q6crlHzGt43v278VUpvuUF+IVfW5m60=";
  };
  vendorHash = "sha256-Bi3cAkcVP1ZWFBuy0RfpqW7yqyV5DxSsa6gmtfLgxEA=";
  pnpmDepsHash = "sha256-uX7+TtZSiVheK7JoZ3mhX2/vcddPezgQ0vY22NF7gNI=";
}
