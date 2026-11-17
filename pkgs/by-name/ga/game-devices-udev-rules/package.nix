{
  lib,
  stdenv,
  bash,
  fetchFromCodeberg,
  meson,
  ninja,
  nix-update-script,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "game-devices-udev-rules";
  version = "1.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "fabiscafe";
    repo = "game-devices-udev";
    tag = finalAttrs.version;
    hash = "sha256-EWEfmKSSnJqVYx8oTxJu2el7bA6hEngHQ0a0kiffdNA=";
  };

  postPatch = ''
    substituteInPlace src/powera-gdu.rules \
      --replace-fail '"/bin/sh -c' '"${lib.getExe bash} -c'
  '';

  nativeBuildInputs = [
    meson
    ninja
    udevCheckHook
  ];

  doInstallCheck = true;
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Udev rules to make supported controllers available with user-grade permissions";
    longDescription = ''
      These udev rules are intended to be used as a package under 'services.udev.packages'.
      They will not be activated if installed as 'environment.systemPackages' or 'users.user.<user>.packages'.
      Additionally, you may need to enable 'hardware.uinput'.
    '';
    homepage = "https://codeberg.org/fabiscafe/game-devices-udev";
    changelog = "https://codeberg.org/fabiscafe/game-devices-udev/src/tag/${finalAttrs.version}/NEWS.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
  };
})
