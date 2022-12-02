{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.23";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-nFN0F80QZh3SALtG3xe6mH0zbhcLSRtmcHosD6aPvrE=";
  };

  vendorSha256 = "sha256-Y5nHADLKCaqHIje7vMS3mAwiGx4tHixBzYZM+iHEZb8=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
