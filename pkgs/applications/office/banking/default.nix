{ lib
, fetchpatch
, fetchFromGitLab
, python3
, appstream-glib
, desktop-file-utils
, glib
, libxml2
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, gobject-introspection
, libadwaita
, librsvg
}:

python3.pkgs.buildPythonApplication rec {
  pname = "banking";
  version = "0.5.1";
  format = "other";

  src = fetchFromGitLab {
    owner = "tabos";
    repo = "banking";
    rev = version;
    sha256 = "sha256-tZlBpDcwQ/aWroP2sFQBZcvmBD26PiY7q/8xFA8GnVc=";
  };

  postPatch = ''
    patchShebangs meson_post_conf.py meson_post_install.py
  '';

  nativeBuildInputs = [
    appstream-glib # for appstream-util
    desktop-file-utils # for desktop-file-validate
    glib # for glib-compile-resources
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gobject-introspection
    libadwaita
    librsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    cryptography
    fints
    mt-940
    pygobject3
    pysqlitecipher
    schwifty
  ];

  meta = with lib; {
    description = "Banking application for small screens";
    homepage = "https://tabos.gitlab.io/projects/banking/";
    license = licenses.gpl3Plus;
    mainProgram = "org.tabos.banking";
    maintainers = with maintainers; [ dotlambda ];
  };
}
