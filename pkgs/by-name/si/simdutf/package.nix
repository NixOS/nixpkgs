{ lib
, stdenv
, fetchFromGitHub
, cmake
, libiconv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "simdutf";
  version = "5.3.7";

  src = fetchFromGitHub {
    owner = "simdutf";
    repo = "simdutf";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n99lt0OYK6OyLArdgPRabQ80ohQgHklpt9saDzKhvJw=";
  };

  # Fix build on darwin
  postPatch = ''
    substituteInPlace tools/CMakeLists.txt --replace "-Wl,--gc-sections" ""
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libiconv
  ];

  meta = with lib; {
    description = "Unicode routines validation and transcoding at billions of characters per second";
    homepage = "https://github.com/simdutf/simdutf";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ rewine ];
    mainProgram = "simdutf";
    platforms = platforms.all;
  };
})
