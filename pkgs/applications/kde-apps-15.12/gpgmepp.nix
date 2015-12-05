{ kdeApp
, lib
, extra-cmake-modules
, boost
, gpgme
}:

kdeApp {
  name = "gpgmepp";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    boost
    gpgme
  ];
  meta = {
    license = with lib.licenses; [ lgpl21 bsd3 ];
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
