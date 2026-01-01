{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libgpiod,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "gcfflasher";
<<<<<<< HEAD
  version = "4.11.0";
=======
  version = "4.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "dresden-elektronik";
    repo = "gcfflasher";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nYLGKem4+Ty2QyhDQIyo9wLEKrbumYKuoGIA9Ore7XM=";
=======
    hash = "sha256-ayPo8FHxlH/xaoIwjbATSYLtGJUJkSj0oS16QoMxsbc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

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

<<<<<<< HEAD
  meta = {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with lib.maintainers; [ fleaz ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with maintainers; [ fleaz ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "GCFFlasher";
  };
}
