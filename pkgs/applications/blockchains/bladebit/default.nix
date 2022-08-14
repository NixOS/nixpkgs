{ lib
, fetchFromGitHub
, stdenv, git
, cmake , numactl, libsodium
, substituteAll
}:

let
  bls = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "bls-signatures";
    rev = "1.0.14";
    sha256 = "sha256-nUBvjCjhQ6GSO8GBZ0oFAGWoR+lclk/vgu2uJRzhYNw=";
    fetchSubmodules = true;
  };

    sodium = fetchFromGitHub {
      owner = "AmineKhaldi";
      repo = "libsodium-cmake";
      rev = "f73a3fe1afdc4e37ac5fe0ddd401bf521f6bba65"; # pinned by upstream
      sha256 = "sha256-lGz7o6DQVAuEc7yTp8bYS2kwjzHwGaNjugDi1ruRJOA=";
      fetchSubmodules = true;
    };

  relic = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "relic";
    rev = "1d98e5abf3ca5b14fd729bd5bcced88ea70ecfd7";
    hash = "sha256-IfTD8DvTEXeLUoKe4Ejafb+PEJW5DV/VXRYuutwGQHU=";
    patches = [(substituteAll {
           src = ./patch_bls.patch;
           inherit sodium;
           inherit relic;
        })];
  };
in
stdenv.mkDerivation {
  pname = "bladebit";
  version = "2.0.0-alpha2";

  src = fetchFromGitHub {
    owner = "Chia-Network";
    repo = "bladebit";
    rev = "v2.0.0-alpha2";
    sha256 = "sha256-xEzOmeXvTa6emzlWCs8rgAY8JMxOHeRBqmaOFh2rzGc=";
    fetchSubmodules = true;
  };

  patchFlags = [ "--binary" ];
  patches = [
    # prevent CMake from trying to get libraries on the Internet
    (substituteAll {
        src = ./find_bls.patch;
        inherit bls;
      })

  ];

  nativeBuildInputs = [ cmake numactl git sodium ];

  buildInputs = [ libsodium ];

  installPhase = ''
    runHook preInstall

    install -D -m 755 bladebit $out/bin/bladebit

    runHook postInstall
  '';

  CXXFLAGS = "-O3 -fmax-errors=1";
  cmakeFlags = [
    "-DBUILD_BLADEBIT_TESTS=false"
  ];

  meta = with lib; {
    homepage = "https://github.com/Chia-Network/bladebit";
    description = "BladeBit - Fast Chia (XCH) k32-only Plotter";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abueide ];
  };
}
