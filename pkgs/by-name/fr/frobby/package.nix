{ stdenv
, fetchFromGitHub
, cmake
, ninja
, gmp
, lib
}: stdenv.mkDerivation (final: {
  pname = "frobby";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "frobby";
    rev = "v${final.version}";
    hash = "sha256-wa1lCqQyctS3hgs84S28aRpU9UCciI0WU9oEjAzhg44=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    gmp
  ];

  meta = with lib; {
    description = "Computations With Monomial Ideals";
    homepage = "https://github.com/Macaulay2/frobby";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ alois31 ];
    sourceProvenance = with sourceTypes; [ fromSource ];
  };
})
