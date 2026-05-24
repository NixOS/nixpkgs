{
  fetchFromGitHub,
  hidapi,
  lib,
  libusb1,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "steam-haptics-singer";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "CrazyCritic89";
    repo = "SteamHapticsSinger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5BhhPgQd36OHMuRsQstPR5Az4uH0uaZ6wyP2PlNWQ70=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    hidapi
    libusb1
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 steam-haptics-singer $out/bin/steam-haptics-singer
    runHook postInstall
  '';

  meta = {
    description = "Program to play MIDI files using haptics from Steam hardware";
    homepage = "https://github.com/CrazyCritic89/SteamHapticsSinger";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "steam-haptics-singer";
    platforms = lib.platforms.linux;
  };
})
