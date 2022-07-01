{ lib
, python3
, fetchFromGitHub
, wrapGAppsHook
, cinnamon
, glib
, gspell
, gtk3
, gobject-introspection
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sticky";
  version = "1.8";
  format = "other";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = pname;
    rev = version;
    hash = "sha256-VSD/QsG7G9hji5m6NSEkCoVM+XK3t4KmCqbocTbZwE4=";
  };

  postPatch = ''
    sed -i -e "s|/usr/share|$out/share|" usr/lib/sticky/*.py
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    gobject-introspection
    cinnamon.xapps
    gspell
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    xapp
  ];

  postBuild = ''
    glib-compile-schemas usr/share/glib-2.0/schemas
  '';

  # hook for gobject-introspection doesn't like strictDeps
  # https://github.com/NixOS/nixpkgs/issues/56943
  strictDeps = false;

  # no tests
  doCheck = false;

  dontWrapGApps = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mv usr/lib $out
    mv usr/share $out
    patchShebangs $out/lib/sticky
    mv $out/lib/sticky/sticky.py $out/bin/sticky
    sed -i -e "1aimport sys;sys.path.append('$out/lib/sticky')" $out/bin/sticky

    runHook postInstall
  '';

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "A sticky notes app for the linux desktop";
    homepage = "https://github.com/linuxmint/sticky";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ linsui ];
  };
}
