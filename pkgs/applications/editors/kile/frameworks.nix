{ kdeDerivation
, lib
, fetchgit
, ecm
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
      version = "2016-10-24";

      src = fetchgit {
        url = git://anongit.kde.org/kile.git;
        rev = "e005e2ac140881aa7610bd363d181cf306f91f80";
        sha256 = "1labv8jagsfk0k7nvxh90in9464avzdabgs215y1h658zjh1wpy4";

      };

      nativeBuildInputs = [ ecm kdoctools ];

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
