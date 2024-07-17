{
  mkDerivation,
  lib,
  fetchpatch,
  fetchurl,
  extra-cmake-modules,
  kdoctools,
  boost,
  qtwebkit,
  qtx11extras,
  shared-mime-info,
  breeze-icons,
  kactivities,
  karchive,
  kcodecs,
  kcompletion,
  kconfig,
  kconfigwidgets,
  kcoreaddons,
  kdbusaddons,
  kdiagram,
  kguiaddons,
  khtml,
  ki18n,
  kiconthemes,
  kitemviews,
  kjobwidgets,
  kcmutils,
  kdelibs4support,
  kio,
  kross,
  knotifications,
  knotifyconfig,
  kparts,
  ktextwidgets,
  kwallet,
  kwidgetsaddons,
  kwindowsystem,
  kxmlgui,
  sonnet,
  threadweaver,
  kcontacts,
  akonadi,
  akonadi-calendar,
  akonadi-contacts,
  eigen,
  git,
  gsl,
  ilmbase,
  kproperty,
  kreport,
  lcms2,
  marble,
  pcre,
  libgit2,
  libodfgen,
  librevenge,
  libvisio,
  libwpd,
  libwpg,
  libwps,
  okular,
  openexr,
  openjpeg,
  phonon,
  poppler,
  pstoedit,
  qca-qt5,
  vc,
  fontconfig,
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
    # Fixes for building calligra with gcc11/c++17
    (fetchpatch {
      name = "build_c++17_poppler.patch";
      url = "https://github.com/archlinux/svntogit-packages/raw/bbbe35f97eb1033798f1cf95d427890168598199/trunk/068cd9ae.patch";
      sha256 = "sha256-d9/ILwSeW+ov11DF191hzIaUafO/rjQrAeONwqDSKbA=";
    })
    # Fixes for building calligra with modern poppler[-qt5]
    (fetchpatch {
      name = "calligra-poppler-22.03.patch";
      url = "https://invent.kde.org/office/calligra/-/commit/236bacbe13739414e919de868283b0caf2df5d8a.patch";
      sha256 = "sha256-9DmKPCvEFy2Cs3g7350iOCF5Vrx1HL+/8jr+Tb44CyE=";
    })
    (fetchpatch {
      name = "calligra-poppler-22.04.patch";
      url = "https://invent.kde.org/office/calligra/-/commit/6b75bec784c9835c78993349845d8c2ef22ec3de.patch";
      sha256 = "sha256-z9/4he4x0WN2K/ZGrDAAtHF/W5X1PAtpeO6s7fgL/fA=";
    })
  ];
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'CMAKE_CXX_STANDARD 11' 'CMAKE_CXX_STANDARD 17'
  '';

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    boost
    qtwebkit
    qtx11extras
    shared-mime-info
    kactivities
    karchive
    kcodecs
    kcompletion
    kconfig
    kconfigwidgets
    kcoreaddons
    kdbusaddons
    kdiagram
    kguiaddons
    khtml
    ki18n
    kiconthemes
    kitemviews
    kjobwidgets
    kcmutils
    kdelibs4support
    kio
    kross
    knotifications
    knotifyconfig
    kparts
    ktextwidgets
    kwallet
    kwidgetsaddons
    kwindowsystem
    kxmlgui
    sonnet
    threadweaver
    kcontacts
    akonadi
    akonadi-calendar
    akonadi-contacts
    eigen
    git
    gsl
    ilmbase
    kproperty
    kreport
    lcms2
    marble
    pcre
    libgit2
    libodfgen
    librevenge
    libvisio
    libwpd
    libwpg
    libwps
    okular
    openexr
    openjpeg
    phonon
    poppler
    qca-qt5
    vc
    fontconfig
  ];

  propagatedUserEnvPkgs = [ kproperty ];

  env.NIX_CFLAGS_COMPILE = "-I${ilmbase.dev}/include/OpenEXR";

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
    maintainers = with maintainers; [
      ebzzry
      zraexy
    ];
    platforms = platforms.linux;
    license = with licenses; [
      gpl2
      lgpl2
    ];
  };
}
