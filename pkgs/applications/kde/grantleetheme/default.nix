{
  mkDerivation, lib, kdepimTeam,
  extra-cmake-modules, kdoctools,
  grantlee, ki18n, kiconthemes, knewstuff, kservice, kxmlgui, qtbase,
}:

mkDerivation {
  pname = "grantleetheme";
  meta = {
    license = with lib.licenses; [ gpl2Plus lgpl21Plus fdl12Plus ];
    maintainers = kdepimTeam;
  };
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    grantlee ki18n kiconthemes knewstuff kservice kxmlgui qtbase
  ];
  propagatedBuildInputs = [ grantlee kiconthemes knewstuff ];
  postInstall = ''
    # added as an include directory by cmake files and fails to compile if it's missing
    mkdir -p "$dev/include/KF5"

    # This is a really disgusting hack, no idea how search paths work for kde,
    # but apparently kde is looking in $out/$out rather than $out for this library.
    # Having this symlink fixes kmail finding it and makes my html work (Yay!).
    mkdir -p $out/$out/lib/grantlee/
    libpath=$(echo $out/lib/grantlee/*)
    ln -s $libpath $out/$out/lib/grantlee/$(basename $libpath)
  '';
}
