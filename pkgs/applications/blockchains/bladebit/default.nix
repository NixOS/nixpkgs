{ lib
, stdenv
, applyPatches
, fetchFromGitHub
, gmp
, numactl
, cmake
, substituteAll
, python3Packages
}:

stdenv.mkDerivation rec {
  pname = "bladebit";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K1VlGI6xW+68jlO7rJmguRzivdDtj04/INr6KbopNKI=";
  };

  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
      src = ./dont_fetch_dependencies.patch;
      blspy_src = applyPatches { inherit (python3Packages.blspy) src patches; };
    })
  ];

  nativeBuildInputs = [ cmake ];

  buildInputs = [ numactl gmp ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 bladebit $out/bin/bladebit

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bladebit";
    description = "Fast Chia (XCH) RAM-only k32-only Plotter";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lourkeur ];
  };
}
