{
  lib,
  stdenv,
  fetchFromGitHub,
  python3Packages,
  wrapGAppsHook3,
  gtk3,
  gobject-introspection,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-pass-search-provider";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "jle64";
    repo = "gnome-pass-search-provider";
    rev = finalAttrs.version;
    hash = "sha256-PDR8fbDoT8IkHiTopQp0zd4DQg7JlacA6NdKYKYmrWw=";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    python3Packages.dbus-python
    python3Packages.pygobject3
    python3Packages.fuzzywuzzy
    python3Packages.levenshtein

    gtk3
    gobject-introspection
  ];

  env = {
    LIBDIR = placeholder "out" + "/lib";
    DATADIR = placeholder "out" + "/share";
  };

  postPatch = ''
    substituteInPlace  conf/org.gnome.Pass.SearchProvider.service.{dbus,systemd} \
      --replace-fail "/usr/lib" "$LIBDIR"
  '';

  installPhase = ''
    runHook preInstall

    bash ./install.sh

    runHook postInstall
  '';

  postFixup = ''
    makeWrapperArgs=( "''${gappsWrapperArgs[@]}" )
    wrapPythonProgramsIn "$out/lib" "$out $propagatedBuildInputs"
  '';

  meta = {
    description = "Pass password manager search provider for gnome-shell";
    homepage = "https://github.com/jle64/gnome-pass-search-provider";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lelgenio ];
    platforms = lib.platforms.linux;
  };
})
