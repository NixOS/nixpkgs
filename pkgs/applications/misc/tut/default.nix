{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.14";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-2zlCO73UBT2E94+AvDdqACotWFna6G1P+Q9VrOKxK+c=";
  };

  vendorSha256 = "sha256-ilq1sfFY6WuNACryDGjkpF5eUTan8Y6Yt26vot9XR54=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
