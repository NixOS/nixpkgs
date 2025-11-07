{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "generaluser";
  version = "2.0.2-unstable-2025-04-21";

  src = fetchFromGitHub {
    owner = "mrbumpy409";
    repo = "GeneralUser-GS";
    rev = "74d4cfe4042a61ddab17d4f86dbccd9d2570eb2a";
    hash = "sha256-I27l8F/BFAo6YSNbtAV14AKVsPIJTHFG2eGudseWmjo=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm644 $src/GeneralUser-GS.sf2 $out/share/soundfonts/GeneralUser-GS.sf2
    runHook postInstall
  '';

  meta = {
    description = "General MIDI SoundFont with a low memory footprint";
    homepage = "https://www.schristiancollins.com/generaluser.php";
    license = lib.licenses.generaluser;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
  };
})
