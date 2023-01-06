{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.30";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-Cr9aDfreTDeFV5mws29pYRUkUjHVcLGEZyUvZYAp3B8=";
  };

  vendorSha256 = "sha256-ECaePGmSaf0vuKbvgdUMOF8oCpc14srFFMmPJPFFqw4=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
