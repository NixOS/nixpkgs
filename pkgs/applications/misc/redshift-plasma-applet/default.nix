{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  plasma-framework,
  kwindowsystem,
  redshift,
  fetchFromGitHub,
  fetchpatch,
}:

let
  version = "1.0.18";
in

stdenv.mkDerivation {
  pname = "redshift-plasma-applet";
  inherit version;

  src = fetchFromGitHub {
    owner = "kotelnik";
    repo = "plasma-applet-redshift-control";
    rev = "v${version}";
    sha256 = "122nnbafa596rxdxlfshxk45lzch8c9342bzj7kzrsjkjg0xr9pq";
  };

  patches = [
    # This patch fetches from out-of-source repo because the GitHub copy is frozen,
    #     the active fork is now on invent.kde.org. Remove this patch when a new version is released and src is updated
    # Redshift version >= 1.12 requires the -P option to clear the existing effects before applying shading.
    #     Without it scrolling makes the screen gets darker and darker until it is impossible to see anything.
    (fetchpatch {
      url = "https://invent.kde.org/plasma/plasma-redshift-control/-/commit/898c3a4cfc6c317915f1e664078d8606497c4049.patch";
      sha256 = "0b6pa3fcj698mgqnc85jbbmcl3qpf418mh06qgsd3c4v237my0nv";
    })
  ];

  patchPhase = ''
    substituteInPlace package/contents/ui/main.qml \
      --replace "redshiftCommand: 'redshift'" \
                "redshiftCommand: '${redshift}/bin/redshift'" \
      --replace "redshiftOneTimeCommand: 'redshift -O " \
                "redshiftOneTimeCommand: '${redshift}/bin/redshift -O "

    substituteInPlace package/contents/ui/config/ConfigAdvanced.qml \
      --replace "'redshift -V'" \
                "'${redshift}/bin/redshift -V'"
  '';

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    plasma-framework
    kwindowsystem
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "KDE Plasma 5 widget for controlling Redshift";
    homepage = "https://github.com/kotelnik/plasma-applet-redshift-control";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      benley
      zraexy
    ];
  };
}
