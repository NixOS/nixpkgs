{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "1k0bmsqgw35sdmaafinlr4qd5910fi598i8irxrz11394d3c8giv";
  };

  modSha256 = "0mk6zp6byq3jc6wipx53bg5igry114klq5w8isc0z6r63zjsk6f6";

  meta = with stdenv.lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
