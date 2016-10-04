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
      version = "2016-07-25";

      src = fetchgit {
        url = git://anongit.kde.org/kile.git;
        rev = "9cad4757df2493a6099b89114340493c6b436d0b";
        sha256 = "0kikrkssfd7bj580iwsipirbz2klxvk0f7nfg5y9mkv0pnchx2mj";

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
kdeWrapper unwrapped
{
  targets = [ "bin/kile" ];
  paths = [ konsole.unwrapped ];
}
