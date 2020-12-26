{
  mkDerivation, lib,
  extra-cmake-modules,
  qtbase, kio, polkit-qt,
  libatasmart, parted,
  util-linux
}:

mkDerivation {
  name = "kpmcore";
  buildInputs = [
    qtbase
    libatasmart
    parted # we only need the library

    kio
    polkit-qt

    util-linux # needs blkid (note that this is not provided by util-linux-compat)
  ];

  #patches = [
  #  ./0001-Fix-polkit-action-installation.patch
  #];
  #POLKIT_ACTION_DIR = "${placeholder "out"}/share/polkit-1/actions";
  #POLKITQT-1_POLICY_FILES_INSTALL_DIR = "$(out)/share/polkit-1/actions";

  postPatch = ''
    sed -i "s|\''${POLKITQT-1_POLICY_FILES_INSTALL_DIR}|''${out}/share/polkit-1/actions|" src/util/CMakeLists.txt
  '';

  #outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules ];

  meta = {
    maintainers = with lib.maintainers; [ peterhoeg ];
    # The build requires at least Qt 5.14.
    broken = lib.versionOlder qtbase.version "5.14";
  };
}
