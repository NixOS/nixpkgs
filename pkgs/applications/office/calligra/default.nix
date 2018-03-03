{
  mkDerivation, lib, fetchurl, fetchpatch, extra-cmake-modules, kdoctools, makeWrapper,
  boost, qtwebkit, qtx11extras, shared-mime-info,
  breeze-icons, kactivities, karchive, kcodecs, kcompletion, kconfig, kconfigwidgets,
  kcoreaddons, kdbusaddons, kdiagram, kguiaddons, khtml, ki18n,
  kiconthemes, kitemviews, kjobwidgets, kcmutils, kdelibs4support, kio, kross,
  knotifications, knotifyconfig, kparts, ktextwidgets, kwallet, kwidgetsaddons,
  kwindowsystem, kxmlgui, sonnet, threadweaver,
  kcontacts, akonadi, akonadi-calendar, akonadi-contacts,
  eigen, git, gsl, ilmbase, kproperty, kreport, lcms2, marble, libgit2, libodfgen,
  librevenge, libvisio, libwpd, libwpg, libwps, okular, openexr, openjpeg, phonon,
  poppler, pstoedit, qca-qt5, vc
# TODO: package Spnav, m2mml LibEtonyek, Libqgit2
}:

mkDerivation rec {
  pname = "calligra";
  version = "3.0.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/${name}.tar.xz";
    sha256 = "1cjdd7sx1zhas6lhw0dzhrnki790jkf93f88wn6z9yrww32dsas5";
  };

  enableParallelBuilding = true;

  patches = [
    (fetchpatch {
      name = "calligra-build-with-newer-kcalcore.patch";
      url = "https://github.com/KDE/calligra/commit/9a02a545e8606aa91aff2038da137226a9432e1a.diff";
      sha256 = "08xays41v6rfnc31vixf4vbz8zmi2x5lfnk7f82bm4sgmpgfxwa0";
    })
  ];

  nativeBuildInputs = [ extra-cmake-modules kdoctools makeWrapper ];

  buildInputs = [
    boost qtwebkit qtx11extras shared-mime-info
    kactivities karchive kcodecs kcompletion kconfig kconfigwidgets kcoreaddons
    kdbusaddons kdiagram kguiaddons khtml ki18n kiconthemes kitemviews
    kjobwidgets kcmutils kdelibs4support kio kross knotifications knotifyconfig kparts
    ktextwidgets kwallet kwidgetsaddons kwindowsystem kxmlgui sonnet threadweaver
    kcontacts akonadi akonadi-calendar akonadi-contacts
    eigen git gsl ilmbase kproperty kreport lcms2 marble libgit2 libodfgen librevenge
    libvisio libwpd libwpg libwps okular openexr openjpeg phonon poppler qca-qt5 vc
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

  postInstall = ''
    for i in $out/bin/*; do
      wrapProgram $i \
        --prefix PATH ':' "${pstoedit.out}/bin" \
        --prefix XDG_DATA_DIRS ':' "${breeze-icons}/share"
    done
  '';

  meta = with lib; {
    description = "A suite of productivity applications";
    longDescription = ''
      Calligra Suite is a set of applications written to help
      you to accomplish your work. Calligra includes efficient
      and capable office components: Words for text processing,
      Sheets for computations, Plan for planning, and Karbon for
      vector graphics.
    '';
    homepage = https://www.calligra.org/;
    maintainers = with maintainers; [ phreedom ebzzry zraexy ];
    platforms = platforms.linux;
    license = with licenses; [ gpl2 lgpl2 ];
  };
}
