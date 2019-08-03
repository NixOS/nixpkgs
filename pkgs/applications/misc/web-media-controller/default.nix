{ stdenv, fetchFromGitHub, cmake, pkgconfig, glib, pcre, json-glib }:

stdenv.mkDerivation rec {
  pname = "wmc-mpris";
  version = "unstable-2019-07-24";

  src = fetchFromGitHub {
    owner = "f1u77y";
    repo = pname;
    rev = "3b92847c576662732984ad791d6c7899a39f7787";
    sha256 = "0q19z0zx53pd237x529rif21kliklwzjrdddx8jfr9hgghjv9giq";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ glib pcre json-glib ];
  cmakeFlags = [
    "-DCHROMIUM_MANIFEST_DESTINATION=${placeholder ''out''}/etc/chromium/native-messaging-hosts"
    "-DCHROME_MANIFEST_DESTINATION=${placeholder ''out''}/etc/opt/chrome/native-messaging-hosts"
    "-DFIREFOX_MANIFEST_DESTINATION=${placeholder ''out''}/lib/mozilla/native-messaging-hosts"
  ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/f1u77y/wmc-mpris";
    description = "MPRIS proxy for usage with 'Web Media Controller' web extension";
    license = licenses.unlicense;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
}
