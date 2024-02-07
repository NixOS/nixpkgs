{ lib
, stdenv
, fetchFromGitHub
, cmake
, libuuid
, expat
, curl
, pcre2
, sqlite
, python3
, boost
, libxml2
, libvirt
, munge
, voms
, perl
, scitoken-cpp
, openssl
}:

stdenv.mkDerivation rec {
  pname = "htcondor";
  version = "23.3.0";

  src = fetchFromGitHub {
    owner = "htcondor";
    repo = "htcondor";

    rev = "v23.3.0";
    hash = "sha256-Ew9leVpvEndiRkOnhx2fLClrNW1bC5djcJEBsve6eIk=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    libuuid
    expat
    openssl
    curl
    pcre2
    sqlite
    python3
    boost
    libxml2
    libvirt
    munge
    voms
    perl
    scitoken-cpp
  ];


  cmakeFlags = [ "-DSYSTEM_NAME=NixOS" "-DWITH_PYTHON_BINDINGS=false" ];

  meta = with lib; {
    homepage = "https://htcondor.org/";
    description =
      "HTCondor is a software system that creates a High-Throughput Computing (HTC) environment";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ evey ];
  };
}
