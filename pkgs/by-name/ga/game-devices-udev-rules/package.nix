{
  lib,
  stdenv,
  fetchFromGitea,
  bash,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "game-devices-udev-rules";
  version = "0.24";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "fabiscafe";
    repo = "game-devices-udev";
    tag = finalAttrs.version;
    hash = "sha256-b2NBgGpRQ2pQZYQgiRSAt0loAxq1NEByRHVkQQRDOj0=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  postInstall = ''
    install -Dm444 -t "$out/lib/udev/rules.d" *.rules
    substituteInPlace $out/lib/udev/rules.d/71-powera-controllers.rules \
    --replace-fail "/bin/sh" "${bash}/bin/bash"
  '';

  meta = {
    description = "Udev rules to make supported controllers available with user-grade permissions";
    homepage = "https://codeberg.org/fabiscafe/game-devices-udev";
    license = lib.licenses.mit;
    longDescription = ''
      These udev rules are intended to be used as a package under 'services.udev.packages'.
      They will not be activated if installed as 'environment.systemPackages' or 'users.user.<user>.packages'.

      Additionally, you may need to enable 'hardware.uinput'.
    '';
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keenanweaver ];
  };
})
