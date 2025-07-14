{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libgpiod,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "gcfflasher";
  version = "4.8.0";

  src = fetchFromGitHub {
    owner = "dresden-elektronik";
    repo = "gcfflasher";
    tag = "v${version}";
    hash = "sha256-W1sL3RyauEYAC/Fj0JhNnk0k5DT6Q8qIEuZNke3xNAE=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/dresden-elektronik/gcfflasher/commit/c1019d7ef2ab55a598ddd938db1b08169b05fc37.patch";
      hash = "sha256-Frd3Xerkv3QolGCOrTE4AqBPqPHTKjjhk+DzhHABTqo=";
    })
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libgpiod
  ];

  installPhase = ''
    runHook preInstall
    install -Dm0755 GCFFlasher $out/bin/GCFFlasher
    runHook postInstall
  '';

  meta = with lib; {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with maintainers; [ fleaz ];
    platforms = platforms.all;
    mainProgram = "GCFFlasher";
  };
}
