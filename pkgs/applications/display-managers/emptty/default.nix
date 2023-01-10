{ buildGoModule
, fetchFromGitHub
, lib
, libX11
, pam
, stdenv
}:

buildGoModule rec {
  pname = "emptty";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "tvrzna";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iT7wdxHC+/3fvBbSrHHuqNYWiqwL48NYzFmtmgVaFik=";
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
