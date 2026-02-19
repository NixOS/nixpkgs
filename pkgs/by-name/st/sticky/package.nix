{
  stdenv,
  lib,
  fetchFromGitHub,
  gobject-introspection,
  meson,
  ninja,
  python3,
  wrapGAppsHook3,
  xapp,
  glib,
  gspell,
  gtk3,
  xapp-symbolic-icons,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sticky";
  version = "1.30";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "sticky";
    rev = finalAttrs.version;
    hash = "sha256-8Y6PoQQHS8h1AT+4DMbExd9y7ScDMig0M9BJQjq09Uc=";
  };

  postPatch = ''
    sed -i -e "s|/usr/lib|$out/lib|" usr/bin/sticky
    sed -i -e "s|/usr/share|$out/share|" usr/lib/sticky/*.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3.pkgs.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    xapp
    glib
    gspell
    gtk3
    python3 # for patchShebangs
  ];

  pythonPath = with python3.pkgs; [
    pygobject3
    python-xapp
  ];

  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  passthru = {
    updateScript = gitUpdater {
      ignoredVersions = "master.*";
    };
  };

  meta = {
    description = "Sticky notes app for the Linux desktop";
    mainProgram = "sticky";
    homepage = "https://github.com/linuxmint/sticky";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      linsui
      bobby285271
    ];
  };
})
