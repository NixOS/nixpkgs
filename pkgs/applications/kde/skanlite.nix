{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kio, libksane
}:

mkDerivation {
  pname = "skanlite";
  meta = with lib; {
    description = "KDE simple image scanning application";
    homepage    = "https://apps.kde.org/skanlite";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ polendri ];
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kio libksane ];
}
