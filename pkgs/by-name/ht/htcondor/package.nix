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
, scitokens-cpp
, openssl
}:

stdenv.mkDerivation rec {
  pname = "htcondor";
  version = "23.4.0";

  src = fetchFromGitHub {
    owner = "htcondor";
    repo = "htcondor";

    rev = "v${version}";
    hash = "sha256-+WfNVxP7qsEpn8zPretLnOEAnPq0GylyxCbcQI8o0L0=";
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
    scitokens-cpp
  ];

  env.CXXFLAGS = "-fpermissive";

  cmakeFlags = [ "-DSYSTEM_NAME=NixOS" "-DWITH_PYTHON_BINDINGS=false" ];

  meta = with lib; {
    homepage = "https://htcondor.org/";
    description =
      "HTCondor is a software system that creates a High-Throughput Computing (HTC) environment";
    platforms = platforms.linux;
    license = licenses.asl20;
    maintainers = with maintainers; [ evey ];
    # cannot find -lpthread: No such file or directory
    broken = stdenv.isAarch64;
  };
}
