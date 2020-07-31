{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "08h14bf4z2gx9sy34jpi2pvxv3i8g9ypl222hzdjsp2ixhl0jia9";
  };

  vendorSha256 = "0q4byhvs1c1xm4qjvs2vyf98vdv121qn0z51arcf7k4ayrys5xcx";

  meta = with stdenv.lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
