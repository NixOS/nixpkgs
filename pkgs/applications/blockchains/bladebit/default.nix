{ lib
, stdenv
, fetchFromGitHub
, applyPatches
, cmake
, numactl
, substituteAll
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "bladebit";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CEpyaWI0FhDUnMJG0IFpWWrjVRlNKEOLPzUBBjQLkTw=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      blspy_src = applyPatches { inherit (python3Packages.blspy) src patches; };
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ numactl ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 bladebit $out/bin/bladebit

    runHook postInstall
  '';


  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bladebit";
    description = "BladeBit - Fast Chia (XCH) k32-only Plotter";
    license = with licenses; [ asl20 ];
    maintainers = teams.chia.members;
    platforms = platforms.linux;
  };
}
