{ lib, stdenv
, fetchFromGitHub
, pkg-config
, libtool
, autoconf
, automake
, curl
, ncurses
, ocl-icd
, opencl-headers
, libusb1
, xorg
, jansson }:

stdenv.mkDerivation rec {
  pname = "cgminer";
  version = "4.11.1";

  src = fetchFromGitHub {
    owner = "ckolivas";
    repo = "cgminer";
    rev = "v${version}";
    sha256 = "0l1ms3nxnjzh4mpiadikvngcr9k3jnjqy3yna207za0va0c28dj5";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ autoconf automake libtool curl ncurses ocl-icd opencl-headers
    xorg.libX11 xorg.libXext xorg.libXinerama jansson libusb1 ];

  configureScript = "./autogen.sh";
  configureFlags = [ "--enable-scrypt"
                     "--enable-opencl"
                     "--enable-bitforce"
                     "--enable-icarus"
                     "--enable-modminer"
                     "--enable-ztex"
                     "--enable-avalon"
                     "--enable-klondike"
                     "--enable-keccak"
                     "--enable-bflsc"];

  meta = with lib; {
    description = "CPU/GPU miner in c for bitcoin";
    homepage = "https://github.com/ckolivas/cgminer";
    license = licenses.gpl3;
    maintainers = with maintainers; [ offline mmahut ];
    platforms = platforms.linux;
  };
}
