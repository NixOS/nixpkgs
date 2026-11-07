{
  lib,
  stdenv,
  _7zz,
  fetchurl,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "meetingbar";
  version = "5.0.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "https://github.com/leits/MeetingBar/releases/download/v${finalAttrs.version}/MeetingBar.dmg";
    hash = "sha256-qxBQjxW/S2xeUgpE5xdX3oOgsCv+iE3jXoMRROMMRUU=";
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
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
