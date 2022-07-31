{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.15";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-gRvX+UvekYDOVcX0ztLmM3OzHwl+FG2i6ATtRYMkQSE=";
  };

  vendorSha256 = "sha256-ddo9b4AXa/6tcbsKZ2e7IXnU47TIIyhBZFk4tbmIdnY=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
