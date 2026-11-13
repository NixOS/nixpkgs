{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "soundfont-generaluser-gs";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "mrbumpy409";
    repo = "GeneralUser-GS";
    rev = "6f2014e815237de02e26e793f8c66c796ba66db5";
    hash = "sha256-/nWcvaAcXDSd/6HapDEa7rDmQD2Q1w6iYsbckh2vnek=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 GeneralUser-GS.sf2 $out/share/soundfonts/GeneralUser-GS.sf2

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/mrbumpy409/GeneralUser-GS/blob/main/documentation/CHANGELOG.md";
    description = "General MIDI SoundFont with a low memory footprint";
    homepage = "https://www.schristiancollins.com/generaluser.php";
    license = lib.licenses.generaluser;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.all;
  };
})
