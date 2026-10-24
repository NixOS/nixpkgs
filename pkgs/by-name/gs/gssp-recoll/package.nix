{
  fetchurl,
  stdenv,
  lib,
  python3,
  gnome-shell,
  wrapGAppsNoGuiHook,
  gobject-introspection,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gssp-recoll";
  version = "1.1.3";
  src = fetchurl {
    url = "https://www.recoll.org/downloads/src/gssp-recoll-${finalAttrs.version}.tar.gz";
    hash = "sha256-HmEEPUNoI7aTEnl2JlpyiK3/y/pVix40iVKE6wBkW9I=";
  };
  # patch the path to the dbus interface file
  postPatch = ''
    substituteInPlace gssp-recoll.py \
      --replace '/usr/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml' \
      '${gnome-shell}/share/dbus-1/interfaces/org.gnome.ShellSearchProvider2.xml'
  '';
  buildInputs = [
    (python3.withPackages (ps: [
      ps.recoll
      ps.pygobject3
      ps.pydbus
    ]))
  ];
  # as a gnome application, it needs to be wrapped
  # with wrapGAppsNoGuiHook and gobject-introspection added as an input
  nativeBuildInputs = [
    wrapGAppsNoGuiHook
    gobject-introspection
  ];
  meta = {
    description = "GNOME Shell Search Provider for Recoll";
    homepage = "https://www.recoll.org";
    downloadPage = "https://www.recoll.org/pages/download.html";
    license = lib.licenses.gpl2Plus;
    mainProgram = "gssp-recoll.py";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ zenmaya ];
  };
})
