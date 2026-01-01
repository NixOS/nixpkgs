{
  lib,
  stdenv,
  fetchurl,
  libotr,
  pidgin,
  intltool,
}:

stdenv.mkDerivation rec {
  pname = "pidgin-otr";
  version = "4.0.2";
  src = fetchurl {
    url = "https://otr.cypherpunks.ca/pidgin-otr-${version}.tar.gz";
    sha256 = "1i5s9rrgbyss9rszq6c6y53hwqyw1k86s40cpsfx5ccl9bprxdgl";
  };

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  nativeBuildInputs = [ intltool ];
  buildInputs = [
    libotr
    pidgin
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://otr.cypherpunks.ca/";
    description = "Plugin for Pidgin 2.x which implements OTR Messaging";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    homepage = "https://otr.cypherpunks.ca/";
    description = "Plugin for Pidgin 2.x which implements OTR Messaging";
    license = licenses.gpl2;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
