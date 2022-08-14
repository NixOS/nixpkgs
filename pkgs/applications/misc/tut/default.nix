{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.17";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-XuN1qpcCUX8xAE7tj21g6U3ilhQIeGWlSqMVik5Qc5Q=";
  };

  vendorSha256 = "sha256-WdhTdF8kdjAg6ztwSwx+smaA0rrLZjE76r4oVJqMtFU=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
