{
  lib,
  fetchFromGitHub,
  stdenv,
  acl,
  glibmm_2_68,
  gtkmm4,
  meson,
  nautilus,
  ninja,
  pkg-config,
  itstool,
  wrapGAppsHook4,
  gtk4,
}:

stdenv.mkDerivation rec {
  pname = "eiciel";
  version = "0.10.1";

  outputs = [
    "out"
    "nautilusExtension"
  ];

  src = fetchFromGitHub {
    owner = "rofirrim";
    repo = "eiciel";
    rev = version;
    sha256 = "sha256-gpuxx1Ts9HCO+3C+Z3k1tVA+1Mip8/Bd+FvWisVdsVY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    wrapGAppsHook4
    gtk4
  ];

  buildInputs = [
    acl
    glibmm_2_68
    gtkmm4
    nautilus
  ];

  mesonFlags = [
    "-Dnautilus-extension-dir=${placeholder "nautilusExtension"}/lib/nautilus/extensions-4"
  ];

  meta = with lib; {
    description = "Graphical editor for ACLs and extended attributes";
    homepage = "https://rofi.roger-ferrer.org/eiciel/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "eiciel";
  };
}
