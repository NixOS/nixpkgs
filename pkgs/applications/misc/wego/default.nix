{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "wego";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "schachmat";
    repo = pname;
    rev = version;
    sha256 = "sha256-lMcrFwYtlnivNjSbzyiAEAVX6ME87yB/Em8Cxb1LUS4=";
  };

  vendorSha256 = "sha256-kv8c0TZdxCIfmkgCLDiNyoGqQZEKUlrNLEbjlG9rSPs=";

  meta = with lib; {
    homepage = "https://github.com/schachmat/wego";
    description = "Weather app for the terminal";
    license = licenses.isc;
  };
}
