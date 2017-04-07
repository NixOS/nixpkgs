{ kdeDerivation
, lib
, fetchgit
, extra-cmake-modules
, kdoctools
, kdeWrapper
, qtscript
, kconfig
, kcrash
, kdbusaddons
, kdelibs4support
, kguiaddons
, kiconthemes
, kinit
, khtml
, konsole
, kparts
, ktexteditor
, kwindowsystem
, poppler
}:

let
  unwrapped =
    kdeDerivation rec {
      name = "kile-${version}";
      version = "2017-02-09";

      src = fetchgit {
        url = git://anongit.kde.org/kile.git;
        rev = "f77f6e627487c152f111e307ad6dc71699ade746";
        sha256 = "0wpqaix9ssa28cm7qqjj0zfrscjgk8s3kmi5b4kk8h583gsrikib";

      };

      nativeBuildInputs = [ extra-cmake-modules kdoctools ];

      buildInputs = [
        kconfig
        kcrash
        kdbusaddons
        kdelibs4support
        kdoctools
        kguiaddons
        kiconthemes
        kinit
        khtml
        kparts
        ktexteditor
        kwindowsystem
        poppler
        qtscript
      ];

      meta = {
        description = "Kile is a user friendly TeX/LaTeX authoring tool for the KDE desktop environment";
        homepage = https://www.kde.org/applications/office/kile/;
        maintainers = with lib.maintainers; [ fridh ];
        license = lib.licenses.gpl2Plus;
      };
    };
in
kdeWrapper
{
  inherit unwrapped;
  targets = [ "bin/kile" ];
  paths = [ konsole.unwrapped ];
}
