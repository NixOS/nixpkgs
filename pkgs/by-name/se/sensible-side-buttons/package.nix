{ lib
, fetchurl
, undmg
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sensible-side-buttons-bin";
  version = "1.0.6";
  src = fetchurl {
    url = "https://github.com/archagon/sensible-side-buttons/releases/download/${finalAttrs.version}/SensibleSideButtons-${finalAttrs.version}.dmg";
    hash = "sha256-Hys678R6wf+M4eg6892rgU3Xxua5dLc9zjaU7HQ1iBs=";
  };

  sourceRoot = "SensibleSideButtons.app";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/SensibleSideButtons.app"
    cp -R . "$out/Applications/SensibleSideButtons.app"
    mkdir "$out/bin"
    ln -s "$out/Applications/SensibleSideButtons.app/Contents/MacOS/SensibleSideButtons" "$out/bin/${finalAttrs.pname}"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Utilize mouse side navigation buttons";
    homepage = "https://sensible-side-buttons.archagon.net";
    license = licenses.unfree;
    maintainers = with maintainers; [ yamashitax ];
    platforms = platforms.darwin;
  };
})
