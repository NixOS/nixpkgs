{
  mkDerivation,
  lib,
  extra-cmake-modules,
  kdoctools,
  kio,
  kparts,
  kwindowsystem,
}:

mkDerivation {
  pname = "keditbookmarks";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kio
    kparts
    kwindowsystem
  ];
  meta = {
    homepage = "http://www.kde.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Plus
      fdl12Plus
      bsd3
    ];
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.linux;
  };
}
