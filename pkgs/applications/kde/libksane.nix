{
  mkDerivation, lib,
  extra-cmake-modules, qtbase,
  ki18n, ktextwidgets, kwallet, kwidgetsaddons,
  sane-backends
}:

mkDerivation {
  name = "libksane";
  meta = with lib; {
    license = licenses.gpl2;
    maintainers = with maintainers; [ pshendry ];
  };
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ki18n ktextwidgets kwallet kwidgetsaddons sane-backends ];
}
