{ lib, stdenv, fetchFromGitHub
, fetchpatch
, avahi
, cups
, gnutls
, libjpeg
, libpng
, libusb1
, pkg-config
, withPAMSupport ? true, pam
, zlib
}:

stdenv.mkDerivation rec {
  pname = "pappl";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-FsmR0fFb9bU9G3oUyJU1eDLcoZ6OQ2//TINlPrW6lU0=";
  };

  patches = [
    (fetchpatch {
      name = "file-offset-bits-64-linux.patch";
      url = "https://github.com/michaelrsweet/pappl/commit/7ec4ce4331b6637c54a37943269e05d15ff6dd47.patch";
      sha256 = "sha256-x5lriopWw6Mn2qjv19flsleEzPMHU4jYWRy0y6hTL5k=";
    })
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    cups
    libjpeg
    libpng
    libusb1
    zlib
  ] ++ lib.optionals (!stdenv.isDarwin) [
    # upstream mentions these are not needed for Mac
    # see: https://github.com/michaelrsweet/pappl#requirements
    avahi
    gnutls
  ] ++ lib.optionals withPAMSupport [
    pam
  ];

  # testing requires some networking
  # doCheck = true;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/pappl-makeresheader --help
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "C-based framework/library for developing CUPS Printer Applications";
    homepage = "https://github.com/michaelrsweet/pappl";
    license = licenses.asl20;
    platforms = platforms.linux; # should also work for darwin, but requires additional work
    maintainers = with maintainers; [ jonringer ];
  };
}
