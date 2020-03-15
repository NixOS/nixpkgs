{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "geoipupdate";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "maxmind";
    repo = "geoipupdate";
    rev = "v${version}";
    sha256 = "057f9kp8g3wixjh9dm58g0qvzfcmhwbk1d573ldly4g5404r9bvf";
  };

  modSha256 = "1bypanvrkcqp8rk84cv2569671irgaf3cy27lcrknyina4pdvir5";

  meta = with stdenv.lib; {
    description = "Automatic GeoIP database updater";
    homepage = "https://github.com/maxmind/geoipupdate";
    license = with licenses; [ asl20 ];
    platforms = platforms.all;
    maintainers = with maintainers; [ das_j ];
  };
}
