{
  mkDerivation,
  lib,
  extra-cmake-modules,
  akonadi-calendar,
  boost,
  kontactinterface,
  krunner,
}:

mkDerivation {
  pname = "zanshin";
  meta = {
    description = "Powerful yet simple application to manage your day to day actions, getting your mind like water";
    homepage = "https://zanshin.kde.org/";
    maintainers = with lib.maintainers; [ zraexy ];
    license = lib.licenses.gpl2Plus;
  };

  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    akonadi-calendar
    boost
    kontactinterface
    krunner
  ];
}
