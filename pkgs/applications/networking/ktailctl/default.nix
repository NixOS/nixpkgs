{ lib
, stdenv
, fetchFromGitHub
, buildGo121Module
, cmake
, extra-cmake-modules
, git
, go_1_21
, wrapQtAppsHook
, qtbase
, qtquickcontrols2
, kconfig
, kcoreaddons
, kguiaddons
, ki18n
, kirigami2
, kirigami-addons
, knotifications
}:

let
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-nY6DEHkDVWIlvc64smXb9KshrhNgNLKiilYydbMKCqc=";
  };

  goDeps = (buildGo121Module {
    pname = "tailwrap";
    inherit src version;
    modRoot = "tailwrap";
    vendorHash = "sha256-Y9xhoTf3vCtiNi5qOPg020EQmASo58BZI3rAoUEC8qE=";
  }).goModules;
in stdenv.mkDerivation {
  pname = "ktailctl";
  inherit version src;

  postPatch = ''
    cp -r --reflink=auto ${goDeps} tailwrap/vendor
  '';

  # needed for go build to work
  preBuild = ''
    export HOME=$TMPDIR
  '';

  cmakeFlags = [
    # actually just disables Go vendoring updates
    "-DKTAILCTL_FLATPAK_BUILD=ON"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    git
    go_1_21
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    kconfig
    kcoreaddons
    kguiaddons
    ki18n
    kirigami2
    kirigami-addons
    knotifications
  ];

  meta = with lib; {
    description = "A GUI to monitor and manage Tailscale on your Linux desktop";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = platforms.all;
  };
}
