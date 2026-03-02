{
  lib,
  stdenv,
  _7zz,
  fetchurl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meetingbar";
  version = "4.11.6";

  src = fetchurl {
    url = "https://github.com/leits/MeetingBar/releases/download/v${finalAttrs.version}/MeetingBar.dmg";
    hash = "sha256-TxmvSW1P9EubDuAr4CvHYgfz42Wn+ed8chmgjGB4ONc=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ _7zz ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -R ./MeetingBar.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Menu-bar app for your calendar meetings";
    homepage = "https://meetingbar.app/";
    changelog = "https://github.com/leits/MeetingBar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ delafthi ];
    platforms = [
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
