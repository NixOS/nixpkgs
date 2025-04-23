{
  stdenv,
  lib,
  fetchFromGitHub,
  hidapi,
  udev,
  pkg-config,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hidapitester";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "hidapitester";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OpLeKTouCB3efsXWJO0lZxUHxtDKeBY7OYk0HwC2NF4=";
  };

  postUnpack = ''
    cp --no-preserve=mode -r ${hidapi.src} hidapi
    export HIDAPI_DIR=$PWD/hidapi
  '';

  env.HIDAPITESTER_VERSION = finalAttrs.version;

  buildInputs = [
    udev
    hidapi
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 hidapitester $out/bin/hidapitester
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Simple command-line program to test HIDAPI";
    homepage = "https://github.com/todbot/hidapitester";
    changelog = "https://github.com/todbot/hidapitester/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ lykos153 ];
    license = lib.licenses.gpl3Only;
    mainProgram = "hidapitester";
  };
})
