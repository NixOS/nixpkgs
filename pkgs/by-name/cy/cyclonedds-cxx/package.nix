{ lib
, stdenv
, fetchFromGitHub
, cmake
, cyclonedds
}:

stdenv.mkDerivation rec {
  pname = "cyclonedds-cxx";
  version = "0.10.5";

  outputs = ["out" "dev"];

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-cxx";
    rev = version;
    hash = "sha256-whFVEQec/Ca+dr6R7z9mMrNg315z3oIWchVT+vQ36So=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cyclonedds ];

  meta = with lib; {
      description = "C++ binding for Eclipse Cyclone DDS";
      homepage = "https://cyclonedds.io/";
      license = with licenses; [ epl20 asl20 ];
      maintainers = with maintainers; [ linbreux ];
    };
}
