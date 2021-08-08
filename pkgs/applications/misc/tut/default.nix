{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "0.0.26";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "1d4n55p9hl4c8i2yz3gq3r7kma7j32pr976dhd7xdwhxadvn3aal";
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
