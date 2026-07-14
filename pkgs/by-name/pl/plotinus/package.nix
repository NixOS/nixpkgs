{
  lib,
  stdenv,
  fetchFromGitHub,
  gettext,
  libxml2,
  pkg-config,
  gtk3,
  cmake,
  ninja,
  vala,
  nixosTests,
  wrapGAppsHook3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plotinus";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "plotinus";
    rev = "v${finalAttrs.version}";
    sha256 = "19k6f6ivg4ab57m62g6fkg85q9sv049snmzq1fyqnqijggwshxfz";
  };

  postPatch = ''
    # CMake 2.8 is deprecated and is no longer supported by CMake > 4
    # https://github.com/NixOS/nixpkgs/issues/445447
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8)" \
        "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    vala
    cmake
    ninja
    gettext
    libxml2
  ];
  buildInputs = [
    gtk3
  ];

  passthru.tests = { inherit (nixosTests) plotinus; };

  meta = {
    description = "Searchable command palette in every modern GTK application";
    homepage = "https://github.com/p-e-w/plotinus";
    maintainers = with lib.maintainers; [ samdroid-apps ];
    platforms = lib.platforms.linux;
    # No COPYING file, but headers in the source code
    license = lib.licenses.gpl3;
  };
})
