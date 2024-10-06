{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  unixtools,
  wrapGAppsHook3,
  gettext,
  gtk3,
  libconfig,
  libusb1,
  libusb-compat-0_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opensuperclone";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "ISpillMyDrink";
    repo = "OpenSuperClone";
    rev = "v${finalAttrs.version}";
    hash = "sha256-vkN+Y8aCyf7jPSxf0O0mfYWtaL9XnDqgjBIUWbGPFH4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    unixtools.xxd
    wrapGAppsHook3
  ];

  buildInputs = [
    gettext
    gtk3
    libconfig
    libusb1
    libusb-compat-0_1
  ];

  cmakeFlags = [ (lib.cmakeFeature "GIT_REVISION" "nixpkgs") ];

  meta = {
    description = "A powerful data recovery utility for Linux with many advanced features";
    homepage = "https://github.com/ISpillMyDrink/OpenSuperClone";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = [ "x86_64-linux" ];
  };
})
