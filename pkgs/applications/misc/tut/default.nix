{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.20";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "03jiv5m807z96796fbpi6ny22am3sq4jfni37fxbld05sxdzwcnd";
  };

  vendorSha256 = "1in5b7ixnm5iizkzziqclvgaq87ccdh507amkgfhfy5sxsgbfb1g";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
