{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  systemd,
  coreutils,
  udevCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brightnessctl";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "Hummer12007";
    repo = "brightnessctl";
    tag = finalAttrs.version;
    hash = "sha256-mApfFFd0aAIW9FrQq9f5OdtxyUC2rWEBerdWqg7rtUY=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "pkg-config" "$PKG_CONFIG"

    substituteInPlace 90-brightnessctl.rules \
      --replace-fail /bin/ ${coreutils}/bin/
  '';

  makeFlags = [
    "PREFIX="
    "DESTDIR=$(out)"
    "ENABLE_SYSTEMD=1"
  ];

  installTargets = [
    "install"
    "install_udev_rules"
  ];

  nativeBuildInputs = [
    pkg-config
    udevCheckHook
  ];
  buildInputs = [ systemd ];

  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/Hummer12007/brightnessctl";
    description = "This program allows you read and control device brightness";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ megheaiulian ];
    platforms = lib.platforms.linux;
    mainProgram = "brightnessctl";
  };

})
