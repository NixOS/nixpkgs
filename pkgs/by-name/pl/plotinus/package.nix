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

stdenv.mkDerivation rec {
  pname = "plotinus";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "p-e-w";
    repo = "plotinus";
    rev = "v${version}";
    sha256 = "19k6f6ivg4ab57m62g6fkg85q9sv049snmzq1fyqnqijggwshxfz";
  };

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

  meta = with lib; {
    description = "Searchable command palette in every modern GTK application";
    homepage = "https://github.com/p-e-w/plotinus";
    maintainers = with maintainers; [ samdroid-apps ];
    platforms = platforms.linux;
    # No COPYING file, but headers in the source code
    license = licenses.gpl3;
  };
}
