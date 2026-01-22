{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  adwaita-icon-theme,
  gmime3,
  webkitgtk_4_1,
  ronn,
  libsass,
  notmuch,
  boost,
  wrapGAppsHook3,
  glib-networking,
  protobuf,
  gtkmm3,
  libpeas,
  gsettings-desktop-schemas,
  gobject-introspection,
  python3,

  # vim to be used, should support the GUI mode.
  vim,

  # additional python3 packages to be available within plugins
  extraPythonPackages ? [ ],
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "astroid";
  version = "0.17";

  src = fetchFromGitHub {
    owner = "astroidmail";
    repo = "astroid";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FDStUt989sQXX6kpqStrdjOdAMlLAepcDba9ul9tcps=";
  };

  postPatch = ''
    sed -i "s~gvim ~${vim}/bin/vim -g ~g" src/config.cc
    sed -i "s~ -geom 10x10~~g" src/config.cc

    # Switch to girepository-2.0
    substituteInPlace src/plugin/gir_main.c \
      --replace-fail "<girepository.h>" "<girepository/girepository.h>" \
      --replace-fail "g_irepository_get_option_group" "gi_repository_get_option_group"
  '';

  nativeBuildInputs = [
    cmake
    ronn
    pkg-config
    wrapGAppsHook3
    gobject-introspection
    python3
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    gtkmm3
    gmime3
    webkitgtk_4_1
    libsass
    libpeas
    python3
    notmuch
    boost
    gsettings-desktop-schemas
    adwaita-icon-theme
    glib-networking
    protobuf
    vim
  ];

  pythonPath = with python3.pkgs; requiredPythonModules extraPythonPackages;
  preFixup = ''
    buildPythonPath "$out $pythonPath"
    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
    )
  '';

  meta = {
    homepage = "https://astroidmail.github.io/";
    description = "GTK frontend to the notmuch mail system";
    mainProgram = "astroid";
    maintainers = with lib.maintainers; [
      bdimcheff
      SuprDewd
    ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
