{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-periphery";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "vsergeev";
    repo = "c-periphery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SojZS/qN+c78wMv8YUhtebDVst18i0qcTJ1WbMY6dbg=";
  };

  postPatch = ''
    substituteInPlace src/libperiphery.pc.in \
      --replace '=''${prefix}/' '=' \
      --replace '=''${exec_prefix}/' '='
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "C library for peripheral I/O (GPIO, LED, PWM, SPI, I2C, MMIO, Serial) in Linux";
    homepage = "https://github.com/vsergeev/c-periphery";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.linux;
  };
})
