{ stdenv, fetchFromGitHub, cmake, pkgconfig, glib, pcre, json-glib }:

stdenv.mkDerivation rec {
  pname = "wmc-mpris";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "f1u77y";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zcnaf9g55cbj9d2zlsr0i15qh0w9gp5jmxkm6dcp1j6yd7j3ymc";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glib pcre json-glib ];
  cmakeFlags = [
    "-DCHROMIUM_MANIFEST_DESTINATION=${placeholder "out"}/etc/chromium/native-messaging-hosts"
    "-DCHROME_MANIFEST_DESTINATION=${placeholder "out"}/etc/opt/chrome/native-messaging-hosts"
    "-DFIREFOX_MANIFEST_DESTINATION=${placeholder "out"}/lib/mozilla/native-messaging-hosts"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/f1u77y/wmc-mpris";
    description = "MPRIS proxy for usage with 'Web Media Controller' web extension";
    license = licenses.unlicense;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
