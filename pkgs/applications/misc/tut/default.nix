{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.34";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-AnuPTv9W+2yDcM803DZaNIn4S7A78JEv6S8pA18whVA=";
  };

  vendorHash = "sha256-go7eZHhrQ1ZcLOn56a3Azn3eRyAesAkgLabPbwzKtds=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
