{ lib, stdenv, fetchFromGitHub
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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "michaelrsweet";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cg06v8hxska0hnybnmfda1v4h3ifjir24nx2iqx80kb6jq0hayb";
  };

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
