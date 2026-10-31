{
  stdenv,
  lib,
  fetchFromGitHub,
  cairo,
  flatpak,
  glib,
  gobject-introspection,
  gtk3,
  hwdata,
  libdrm,
  meson,
  ninja,
  python3,
  python3Packages,
  upower,
  wrapGAppsHook3,
  xapp,
  xapp-symbolic-icons,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "superlight";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "xapp-project";
    repo = "superlight";
    tag = finalAttrs.version;
    hash = "sha256-HgGoWUc6hhWOZjnBsWSqfmdzQ2/Q4HOoe0o+j7NTpo0=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    python3
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  buildInputs = [
    cairo
    flatpak
    glib
    gtk3
    python3
    upower
    xapp
  ];

  pythonPath = with python3Packages; [
    pycairo
    pygobject3
    python-xapp
    setproctitle
  ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "/usr/bin/python3" "python3"

    substituteInPlace superlight/common_proc.py \
      --replace-fail "/usr/share/libdrm/amdgpu.ids" "${libdrm}/share/libdrm/amdgpu.ids" \
      --replace-fail "/usr/share/hwdata/pci.ids" "${hwdata}/share/hwdata/pci.ids"
  '';

  preFixup = ''
    buildPythonPath "$out ''${pythonPath[*]}"

    gappsWrapperArgs+=(
      --prefix PYTHONPATH : "$program_PYTHONPATH"
      --prefix XDG_DATA_DIRS : "${lib.makeSearchPath "share" [ xapp-symbolic-icons ]}"
    )
  '';

  meta = {
    description = "System monitor for Linux desktops";
    mainProgram = "superlight";
    homepage = "https://github.com/xapp-project/superlight";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.cinnamon ];
  };
})
