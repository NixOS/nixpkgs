{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sml";
  version = "1.1.9";

  src = fetchFromGitHub {
    owner = "boost-ext";
    repo = "sml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-RYgSpnsmgZybpkJALIzxpkDRfe9QF2FHG+nA3msFaK0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "SML: C++14 State Machine Library";
    homepage = "https://github.com/boost-ext/sml";
    license = licenses.boost;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
})

