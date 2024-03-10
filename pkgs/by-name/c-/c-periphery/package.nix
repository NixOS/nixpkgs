{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "c-periphery";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "vsergeev";
    repo = "c-periphery";
    rev = "v${finalAttrs.version}";
    hash = "sha256-uUSXvMQcntUqD412UWkMif0wLxPhpPdnMb96Pqqh/B4=";
  };

  outputs = [ "dev" "lib" "out" ];

  postPatch = ''
    substituteInPlace src/libperiphery.pc.in \
      --replace '=''${prefix}/' '=' \
      --replace '=''${exec_prefix}/' '='
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A C library for peripheral I/O (GPIO, LED, PWM, SPI, I2C, MMIO, Serial) in Linux";
    homepage = "https://github.com/vsergeev/c-periphery";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
})
