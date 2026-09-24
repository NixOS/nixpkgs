{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  udevCheckHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "apio-udev-rules";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "apio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VU4tOszGkw20DWW2SerFsnjFiSkrSwqBcwosGnHJfU8=";
  };

  dontBuild = true;

  nativeBuildInputs = [
    udevCheckHook
  ];

  doInstallCheck = true;

  # 80-* renamed to 70-* for uaccess TAG
  installPhase = ''
    runHook preInstall
    install -D apio/resources/80-fpga-ftdi.rules $out/lib/udev/rules.d/70-fpga-ftdi.rules
    install -D apio/resources/80-fpga-serial.rules $out/lib/udev/rules.d/70-fpga-serial.rules
    runHook postInstall
  '';

  meta = {
    description = "Apio udev rules list";
    homepage = "https://github.com/FPGAwars/apio";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ zh4ngx ];
  };
})
