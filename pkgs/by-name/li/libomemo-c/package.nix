{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "libomemo-c";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "dino";
    repo = "libomemo-c";
    rev = "v${version}";
    hash = "sha256-GvHMp0FWoApbYLMhKfNxSBel1xxWWF3TZ4lnkLvu2s4=";
  };

  nativeBuildInputs = [ cmake ];
  buildsInputs = [ openssl ];
  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  meta = with lib; {
    description = "Fork of libsignal-protocol-c adding support for OMEMO XEP-0384 0.5.0+";
    homepage = "https://github.com/dino/libomemo-c";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.astro ];
  };
}
