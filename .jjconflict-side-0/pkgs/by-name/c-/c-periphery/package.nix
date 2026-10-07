{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-periphery";
  version = "2.5.1";

  src = fetchFromGitHub {
    owner = "vsergeev";
    repo = "c-periphery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IqQ9gmbh/bkQ6fwYegPPvqpHPTD9TJDQV7sPxuDNw7k=";
  };

  outputs = [
    "dev"
    "lib"
    "out"
  ];

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
