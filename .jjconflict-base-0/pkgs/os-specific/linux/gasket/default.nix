{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch2,
  kernel,
}:

stdenv.mkDerivation rec {
  pname = "gasket";
  version = "1.0-18-unstable-2024-04-25";

  src = fetchFromGitHub {
    owner = "google";
    repo = "gasket-driver";
    rev = "5815ee3908a46a415aac616ac7b9aedcb98a504c";
    sha256 = "O17+msok1fY5tdX1DvqYVw6plkUDF25i8sqwd6mxYf8=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/google/gasket-driver/issues/36
      # https://github.com/google/gasket-driver/pull/35
      name = "linux-6.12-compat.patch";
      url = "https://github.com/google/gasket-driver/commit/4b2a1464f3b619daaf0f6c664c954a42c4b7ce00.patch";
      hash = "sha256-UOoOSEnpUMa4QXWVFpGFxBoF5szXaLEfcWtfKatO5XY=";
    })
  ];

  postPatch = ''
    cd src
  '';

  makeFlags = kernel.makeFlags ++ [
    "-C"
    "${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "M=$(PWD)"
  ];
  buildFlags = [ "modules" ];

  installFlags = [ "INSTALL_MOD_PATH=${placeholder "out"}" ];
  installTargets = [ "modules_install" ];

  hardeningDisable = [
    "pic"
    "format"
  ];
  nativeBuildInputs = kernel.moduleBuildDependencies;

  meta = with lib; {
    description = "Coral Gasket Driver allows usage of the Coral EdgeTPU on Linux systems";
    homepage = "https://github.com/google/gasket-driver";
    license = licenses.gpl2Only;
    maintainers = [ lib.maintainers.kylehendricks ];
    platforms = platforms.linux;
    broken = versionOlder kernel.version "5.15";
  };
}
