{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.41";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-13d3EE/rswcHRALUfL46qpKYJUDwGiou5kUz+nCC8VQ=";
  };

  vendorSha256 = "sha256-RtvzQvZIFdLo24U9IWcoL9qnf4/q/+1UCrb7dcRKEIE=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
