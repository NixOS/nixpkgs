{
  mkDerivation, fetchurl, lib,
  extra-cmake-modules, kdoctools,
  knotifyconfig, kidletime, kwindowsystem, ktextwidgets, kcrash
}:

let
  pname = "rsibreak";
  version = "0.12";
  revision = ".8";
in mkDerivation rec {
  name = "rsibreak-${version}${revision}";

  src = fetchurl {
    url = "https://download.kde.org/stable/${pname}/${version}/${name}.tar.xz";
    sha256 = "1qn9xdjx9zzw47jsj7f4nkqmrangfhdgafm2jxm7cm6z6kcvzr28";
  };

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [ knotifyconfig kidletime kwindowsystem ktextwidgets kcrash ];

  meta = with lib; {
    description = "RSIBreak takes care of your health and regularly breaks your work to avoid repetitive strain injury (RSI)";
    license = licenses.gpl2;
    homepage = https://www.kde.org/applications/utilities/rsibreak/;
    maintainers = with maintainers; [ vandenoever ];
  };
}
