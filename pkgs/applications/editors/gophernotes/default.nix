{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "gophernotes";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "gopherdata";
    repo = "gophernotes";
    rev = "v${version}";
    sha256 = "sha256-ZyZ5VOZEgFn9QrFBC1bNHKA2g8msDUnd1c5plooO+b8=";
  };

  vendorSha256 = "sha256-NH8Hz9SzmDksvGqCpggi6hG4kW+AoA1tctF6rGgy4H4=";

  meta = with lib; {
    description = "Go kernel for Jupyter notebooks";
    homepage = "https://github.com/gopherdata/gophernotes";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
