{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "tut";
  version = "1.0.25";

  src = fetchFromGitHub {
    owner = "RasmusLindroth";
    repo = pname;
    rev = version;
    sha256 = "sha256-wSCT8GaBMBzxtPsspc+kS4mMVayMEBBSzXZB3dQ3Nj8=";
  };

  vendorSha256 = "sha256-dyt7JDHsmbdMccIHVaG6N1lAwcM5xKeYoZ2Giwfkgqc=";

  meta = with lib; {
    description = "A TUI for Mastodon with vim inspired keys";
    homepage = "https://github.com/RasmusLindroth/tut";
    license = licenses.mit;
    maintainers = with maintainers; [ equirosa ];
    platforms = platforms.unix;
  };
}
