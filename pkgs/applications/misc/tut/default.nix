{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.36";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-Ew/nrsJivq/3/vlZnR1gwhqzQQ9YmrW2LPD7qjmPH4A=";
  };

  vendorSha256 = "sha256-Q1H/Y2mDTr24JQMoTf8DL3cj5oF9lH0uaJD2g/0Yxko=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
