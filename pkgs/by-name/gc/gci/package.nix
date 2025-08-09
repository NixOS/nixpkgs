{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "gci";
  version = "0.13.6";

  src = fetchFromGitHub {
    owner = "daixiang0";
    repo = "gci";
    rev = "v${version}";
    sha256 = "sha256-BlR7lQnp9WMjSN5IJOK2HIKXIAkn5Pemf8qbMm83+/w=";
  };

  vendorHash = "sha256-/8fggERlHySyimrGOHkDERbCPZJWqojycaifNPF6MjE=";

  meta = with lib; {
    description = "Controls golang package import order and makes it always deterministic";
    homepage = "https://github.com/daixiang0/gci";
    license = licenses.bsd3;
    maintainers = with maintainers; [ krostar ];
  };
}
