{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, pam
, stdenv
}:

buildGoModule rec {
  pname = "emptty";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nReExxLbqlbzx1F1vk8qftWafG8umH988egsalSUals=";
  };

  buildInputs = [ pam libX11 ];

  vendorHash = "sha256-tviPb05puHvBdDkSsRrBExUVxQy+DzmkjB+W9W2CG4M=";

  meta = with lib; {
    description = "Dead simple CLI Display Manager on TTY";
    homepage = "https://github.com/tvrzna/emptty";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
    # many undefined functions
    broken = stdenv.isDarwin;
  };
}
