{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.13";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-EORvIqA2bsmNUY1euUBmEYNMU02nW0doRDmTQjt15Os=";
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
