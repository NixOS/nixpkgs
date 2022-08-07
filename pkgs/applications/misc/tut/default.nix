{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.16";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-sJX9qpWkNe/v9PSAJ5iY8RKEJXs84Gf0Imce4VIFp2Q=";
  };

  vendorSha256 = "sha256-LAVvaZqZzMYCGtVWmeYXI7L4f2tStkaWG4QlLSrSjfk=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
