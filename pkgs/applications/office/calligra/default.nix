{ mkDerivation, lib, fetchpatch, fetchurl, extra-cmake-modules, kdoctools
, boost, qtwebkit, qtx11extras, shared-mime-info
, breeze-icons, kactivities, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets
, kcoreaddons, kdbusaddons, kdiagram, kguiaddons, khtml, ki18n
, kiconthemes, kitemviews, kjobwidgets, kcmutils, kdelibs4support, kio, kross
, knotifications, knotifyconfig, kparts, ktextwidgets, kwallet, kwidgetsaddons
, kwindowsystem, kxmlgui, sonnet, threadweaver
, kcontacts, akonadi, akonadi-calendar, akonadi-contacts
, eigen, git, gsl, ilmbase, kproperty, kreport, lcms2, marble, pcre, libgit2, libodfgen
, librevenge, libvisio, libwpd, libwpg, libwps, okular, openexr, openjpeg, phonon
, poppler, pstoedit, qca-qt5, vc, fontconfig
# TODO: package Spnav, m2mml LibEtonyek, Libqgit2
}:

mkDerivation rec {
  pname = "calligra";
  version = "3.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${pname}-${version}.tar.xz";
    sha256 = "0iqi6z6gkck2afgy200dacgcspq7i7887alcj0pklm08hbmsdy5i";
  };

  patches = [
    # Fix fontconfig underlinking: https://github.com/NixOS/nixpkgs/issues/137794
    # Can be dropped on next release.
    (fetchpatch {
      name = "fix-fontconfig-linking.patch";
      url = "https://github.com/KDE/calligra/commit/62f510702ef9c34ac50f8d8601a4290ab558464c.patch";
      sha256 = "11dzrp9q05dmvnwp4vk4ihcibqcf4xyr0ijscpi716cyy730flma";
      excludes = [ "CMakeLists.txt" ];
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools ];

  buildInputs = [
    boost qtwebkit qtx11extras shared-mime-info
    kactivities karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons kdiagram kguiaddons khtml ki18n kiconthemes kitemviews
    kjobwidgets kcmutils kdelibs4support kio kross knotifications knotifyconfig kparts
    ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui sonnet threadweaver
    kcontacts akonadi akonadi-calendar akonadi-contacts
    eigen git gsl ilmbase kproperty kreport lcms2 marble pcre libgit2 libodfgen librevenge
    libvisio libwpd libwpg libwps okular openexr openjpeg phonon poppler qca-qt5 vc
    fontconfig
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  qtWrapperArgs = [
    "--prefix PATH : ${lib.getBin pstoedit}/bin"
    "--prefix XDG_DATA_DIRS : ${breeze-icons}/share"
  ];

  meta = with lib; {
    description = "A suite of productivity applications";
    longDescription = ''
      Calligra Suite is a set of applications written to help
      you to accomplish your work. Calligra includes efficient
      and capable office components: Words for text processing,
      Sheets for computations, Plan for planning, and Karbon for
      vector graphics.
    '';
    homepage = "https://www.calligra.org/";
    maintainers = with maintainers; [ phreedom ebzzry zraexy ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
