{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
, libssh
, curl
, libyang
, pcre2
, libxcrypt
, validatePkgConfig
}:

stdenv.mkDerivation rec {
  pname = "libnetconf2";
  version = "3.0.8";

  src = fetchFromGitHub {
    owner = "CESNET";
    repo = "libnetconf2";
    rev = "v${version}";
    hash = "sha256-MEub9bElAm8SIwRDUsAyURKeEF7cau/ZtmRNvlB3wn4=";
  };

  postPatch = ''
    substituteInPlace libnetconf2.pc.in \
      --replace "\''${prefix}/@CMAKE_INSTALL_LIBDIR@" "\''${prefix}/lib" \
      --replace "\''${prefix}/@CMAKE_INSTALL_INCLUDEDIR@" "\''${prefix}/include"
  '';

  nativeBuildInputs = [
    cmake
    validatePkgConfig
  ];

  buildInputs = [
    openssl
    libssh
    curl
    libyang
    # Hidden dependencies but necessary ones
    pcre2
    libxcrypt
  ];

  meta = with lib; {
    description = "C NETCONF library";
    longDescription = ''
      libnetconf2 is a NETCONF library in C intended for building NETCONF clients and
      servers. NETCONF is the NETwork CONFiguration protocol introduced by
      IETF in RFC 4741 and RFC 6241.
    '';
    homepage = "https://github.com/CESNET/libnetconf2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
    mainProgram = "libnetconf2";
    platforms = platforms.all;
  };
}
