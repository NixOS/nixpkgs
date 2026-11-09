{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libgpiod,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gcfflasher";
  version = "4.12.2";

  src = fetchFromGitHub {
    owner = "dresden-elektronik";
    repo = "gcfflasher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OdVysCsbAUb0J7f+urj/dixzZhuYuotwmkhq57HUR7Q=";
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

  meta = {
    description = "CFFlasher is the tool to program the firmware of dresden elektronik's Zigbee products";
    license = lib.licenses.bsd3;
    homepage = "https://github.com/dresden-elektronik/gcfflasher";
    maintainers = with lib.maintainers; [ fleaz ];
    platforms = lib.platforms.all;
    mainProgram = "GCFFlasher";
  };
})
