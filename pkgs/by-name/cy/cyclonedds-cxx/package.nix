{ lib
, stdenv
, fetchFromGitHub
, cmake
, cyclonedds
}:

stdenv.mkDerivation rec {
  pname = "cyclonedds-cxx";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-cxx";
    rev = version;
    sha256 = "sha256-/Bb4lhDeJFCZpsf+EfKSJpX5Xv5mFms5miw36be1goQ=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cyclonedds ];

  meta = with lib;
    {
      description = "C++ binding for Eclipse Cyclone DDS";
      homepage = "https://cyclonedds.io/";
      license = with licenses; [ epl20 ];
      maintainers = with maintainers; [ linbreux ];
    };
}
