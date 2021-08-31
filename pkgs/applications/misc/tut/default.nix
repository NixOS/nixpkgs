{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.27";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-P5tIu6cmh37haWJodBGmzgE8f0QUTwIQes9AuiaVSxU=";
  };

  vendorSha256 = "1zmwfgl1mayqcqk93368l94d6yah1qb0x11vf9b2x7zbzxzfshg9";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
