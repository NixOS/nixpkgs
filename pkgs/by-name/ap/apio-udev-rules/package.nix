{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apio-udev-rules";
  version = "0.9.5";

  src = fetchFromGitHub {
    owner = "FPGAwars";
    repo = "apio";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VU4tOszGkw20DWW2SerFsnjFiSkrSwqBcwosGnHJfU8=";
  };

  dontBuild = true;

  # 80-* renamed to 70-* for uaccess TAG
  installPhase = ''
    runHook preInstall
    install -D apio/resources/80-fpga-ftdi.rules $out/lib/udev/rules.d/70-fpga-ftdi.rules
    install -D apio/resources/80-fpga-serial.rules $out/lib/udev/rules.d/70-fpga-serial.rules
    runHook postInstall
  '';

  meta = with lib; {
    description = "apio udev rules list";
    homepage = "https://github.com/FPGAwars/apio";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ zh4ngx ];
  };
})
