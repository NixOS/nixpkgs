{
  mkDerivation, lib,
  extra-cmake-modules, qtbase,
  ki18n, ktextwidgets, kwallet, kwidgetsaddons,
  sane-backends
}:

mkDerivation {
  pname = "libksane";
  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ polendri ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n ktextwidgets kwallet kwidgetsaddons sane-backends ];
}
