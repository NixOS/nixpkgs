{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  python3Packages,
  autoPatchelfHook,
  pkgs,
}:

stdenvNoCC.mkDerivation rec {
  pname = "ice-ssb";
  version = "6.0.8";

  src = fetchFromGitHub {
    owner = "peppermintos";
    repo = "ice";
    tag = "v${version}";
    hash = "sha256-gVcnNJEzU2rhzyBdO5HJUvh+moQ3q4AxNI4KcSboX5Q=";
  };

  patches = [ ./browser-paths.patch ];

  nativeBuildInputs = [
    autoPatchelfHook
    python3Packages.wrapPython
  ];

  buildInputs = with pkgs; [
    gobject-introspection
    gtk3
    wrapGAppsHook3
  ];

  propagatedBuildInputs = with python3Packages; [
    beautifulsoup4
    pygobject3
    lxml
    requests
  ];

  postPatch = ''
    substituteInPlace usr/bin/ice \
      --replace "/usr/share/pixmaps/ice.png" "$out/share/pixmaps/ice.png"
    substituteInPlace usr/bin/ice-firefox \
      --replace "/usr/share/pixmaps/ice.png" "$out/share/pixmaps/ice.png"
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r -f usr/bin/* $out/bin
    chmod +x $out/bin/*

    mkdir -p $out/lib
    cp -r -f usr/lib/* $out/lib

    mkdir -p $out/share
    cp -r -f usr/share/* $out/share

    wrapPythonProgramsIn $out/bin "$propagatedBuildInputs"
  '';

  meta = {
    description = "Simple Site Specific Browser (SSB) manager";
    homepage = "https://github.com/peppermintos/ice";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ sunworms ];
  };
}
