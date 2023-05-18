{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "levant";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "levant";
    rev = "v${version}";
    sha256 = "sha256-UI8PVvTqk8D4S9kq3sgxrm8dkRokpgkLyTN6pzUXNV0=";
  };

  vendorSha256 = "sha256-MzKttGfuIg0Pp/iz68EpXuk4I+tFozhIabKlsWuvJ48=";

  # The tests try to connect to a Nomad cluster.
  doCheck = false;

  meta = with lib; {
    description = "An open source templating and deployment tool for HashiCorp Nomad jobs";
    homepage = "https://github.com/hashicorp/levant";
    license = licenses.mpl20;
    maintainers = with maintainers; [ max-niederman ];
    platforms = platforms.unix;
  };
}
