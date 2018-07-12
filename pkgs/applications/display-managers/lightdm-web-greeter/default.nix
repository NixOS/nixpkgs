{ lib
, fetchFromGitHub
, makeWrapper
, buildPythonApplication
, whither
, zip
, pygobject3
, lightdm
, gobjectIntrospection
, qt5
}:

let
  inherit (qt5) qtbase;
in
buildPythonApplication rec {
  version = "3.0.0rc2";
  name = "lightdm-web-greeter-${version}";

  outputs = [ "out" "theme" ];

  src = fetchFromGitHub {
    owner = "Antergos";
    repo = "web-greeter";
    rev = "${version}";
    sha256 = "1mhqnvc77m483sm4mj08qq1gzidkfkgn7xhaj3dgs65lndsxrwnn";
  };

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  postPatch = ''
    patchShebangs build/utils.sh
  '';

  buildInputs = [
    zip
    whither
    makeWrapper
    pygobject3
    lightdm
    qtbase
  ];

  nativeBuildInputs = [
    gobjectIntrospection
  ];

  installPhase = ''
    make -j1 \
      PREFIX="/" \
      DESTDIR="$out" \
      themes_dir="/run/current-system/sw/share/web-greeter/themes" \
      install

    patchShebangs $out/bin/

    wrapProgram $out/bin/web-greeter \
      --set QT_PLUGIN_PATH ${qtbase.bin}/${qtbase.qtPluginPrefix} \
      --set QTWEBENGINE_CHROMIUM_FLAGS "--enable-logging --log-level=0 --v=1" \
      --prefix PYTHONPATH      : "$PYTHONPATH" \
      --prefix GI_TYPELIB_PATH : "$GI_TYPELIB_PATH"

    # Move themes into `theme`
    mkdir -p $theme/share/
    # _vendor is needed :(
    mv -v $out/share/web-greeter $theme/share/
  '';

  meta = with lib; {
    homepage = https://github.com/Antergos/web-greeter;
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ samueldr ];
  };
}
