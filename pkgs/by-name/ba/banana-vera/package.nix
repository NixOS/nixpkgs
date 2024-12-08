{ lib
, stdenv
, fetchFromGitHub
, cmake
, python310
, tcl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "banana-vera";
  version = "1.3.0-ubuntu";

  src = fetchFromGitHub {
    owner = "Epitech";
    repo = "banana-vera";
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-sSN3trSySJe3KVyrb/hc5HUGRS4M3c4UX9SLlzBM43c=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    python310
    python310.pkgs.boost
    tcl
  ];

  cmakeFlags = [
    "-DVERA_LUA=OFF"
    "-DVERA_USE_SYSTEM_BOOST=ON"
    "-DPANDOC=OFF"
  ];

  meta = {
    mainProgram = "vera++";
    description = "Fork of vera using python3.10";
    homepage = "https://github.com/Epitech/banana-vera";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
