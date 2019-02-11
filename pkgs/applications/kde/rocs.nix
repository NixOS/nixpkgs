{
  stdenv, mkDerivation, makeWrapper, lib,
  extra-cmake-modules, boost,
  qtbase, qtscript, qtquickcontrols, qtwebkit, qtxmlpatterns, grantlee,
  kdoctools, karchive, kxmlgui, kcrash, kdeclarative, ktexteditor, kguiaddons
}:

mkDerivation {
  name = "rocs";
  nativeBuildInputs = [ extra-cmake-modules makeWrapper kdoctools ];
  buildInputs = [
    boost
    qtbase qtscript qtquickcontrols qtwebkit qtxmlpatterns grantlee
    kxmlgui kcrash kdeclarative karchive ktexteditor kguiaddons
  ];
  postInstall = ''
    wrapProgram $out/bin/rocs --prefix QT_PLUGIN_PATH ":" "${qtbase.bin}/${qtbase.qtPluginPrefix}:$out/${qtbase.qtPluginPrefix}"
  '';
  meta = with lib; {
    homepage = http://www.kde.org;
    license = with licenses; [ gpl2 lgpl21 fdl12 ];
    platforms = lib.platforms.linux;
    maintainers = with maintainers; [ knairda ];
  };
}
