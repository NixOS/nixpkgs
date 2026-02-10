{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gettext,
  glib,
  nautilus,
  nautilus-python,
  python3,
  gedit,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nautilus-admin";
  version = "1.2.0";
  src = fetchFromGitHub {
    owner = "MacTavishAO";
    repo = "nautilus-admin-gtk4";
    rev = "${finalAttrs.version}";
    hash = "sha256-UJe9gbMm2Dt4JVJ7GI7DX4+3W5W4WZP4JcJ5iN3e3G4=";
  };

  nativeBuildInputs = [
    cmake
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    nautilus
    nautilus-python
    python3
    gedit
  ];

  postPatch = ''
    sed -i 's/cmake_minimum_required(VERSION [0-9.]*)/cmake_minimum_required(VERSION 3.5)/' CMakeLists.txt

    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /usr/share" "DESTINATION share"
  '';

  cmakeFlags = [
    "-DNAUTILUS_PATH=${nautilus}/bin/nautilus"
    "-DGEDIT_PATH=${gedit}/bin/gedit"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  meta = with lib; {
    description = "Extension for Nautilus to do administrative operations";
    homepage = "https://github.com/MacTavishAO/nautilus-admin-gtk4";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
})
