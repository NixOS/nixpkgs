{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libtool,
  autoconf,
  automake,
  curl,
  ncurses,
  ocl-icd,
  opencl-headers,
  libusb1,
  libxinerama,
  libxext,
  libx11,
  jansson,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cgminer";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = "cgminer";
    rev = "v${finalAttrs.version}";
    sha256 = "0l1ms3nxnjzh4mpiadikvngcr9k3jnjqy3yna207za0va0c28dj5";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
  ];
  buildInputs = [
    libtool
    curl
    ncurses
    ocl-icd
    opencl-headers
    libx11
    libxext
    libxinerama
    jansson
    libusb1
  ];

  configureScript = "./autogen.sh";
  configureFlags = [
    "--enable-scrypt"
    "--enable-opencl"
    "--enable-bitforce"
    "--enable-icarus"
    "--enable-modminer"
    "--enable-ztex"
    "--enable-avalon"
    "--enable-klondike"
    "--enable-keccak"
    "--enable-bflsc"
  ];

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: cgminer-driver-modminer.o:/build/source/miner.h:285:
  #     multiple definition of `bitforce_drv'; cgminer-cgminer.o:/build/source/miner.h:285:
  #     first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  meta = {
    description = "CPU/GPU miner in c for bitcoin";
    mainProgram = "cgminer";
    homepage = "https://github.com/ckolivas/cgminer";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      mmahut
    ];
    platforms = lib.platforms.linux;
  };
})
