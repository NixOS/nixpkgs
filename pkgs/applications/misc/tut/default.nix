{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.19";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-lT/3KXxrZYOK/oGrlorQUIv8J7tAfME0hRb1bwN+nXA=";
  };

  vendorSha256 = "sha256-O7tre7eSGlB9mnf/9aNbe/Ji0ecmJyuLuaWKARskCjI=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
