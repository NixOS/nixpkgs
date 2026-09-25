{
  lib,
  stdenv,
  fetchFromGitHub,
  udevCheckHook,
}:

## Usage
# In NixOS, set hardware.keyboard.qmk.enable = true;

stdenv.mkDerivation (finalAttrs: {
  pname = "qmk-udev-rules";
  version = "0.1.23";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_udev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LpyYjngahl4ws0e8l3cSYiPc23Okiq1uhff/oAj9uMo=";
  };

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  installFlags = [
    "PREFIX=$(out)"
  ];

  postInstall = ''
    substituteInPlace $out/lib/udev/rules.d/50-qmk.rules \
      --replace-fail 'qmk_id %S%p' "$out/lib/udev/qmk_id %S%p"
  '';

  meta = {
    homepage = "https://github.com/qmk/qmk_udev";
    description = "A small program that udev uses to identify QMK keyboards";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      miniharinn
      kaezrr
    ];
  };
})
