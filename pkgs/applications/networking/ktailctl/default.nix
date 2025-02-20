{
  buildGo123Module,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  git,
  go_1_23,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  kguiaddons,
  ki18n,
  kirigami,
  kirigami-addons,
  knotifications,
  kwindowsystem,
  lib,
  nlohmann_json,
  qqc2-desktop-style,
  qtbase,
  qtdeclarative,
  qtsvg,
  qtwayland,
  stdenv,
  wrapQtAppsHook,
}:

let
  version = "0.19.3";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-0P3cvBI5CM03y6Km7d31Z3ZzpGW3y1oKkprpPglrujg=";
  };

  goDeps =
    (buildGo123Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-o7eH3f+yeRr5CnBIuL2jMtVQaBLVihz2dg5RTF8RvaM=";
    }).goModules;
in
stdenv.mkDerivation {
  pname = "ktailctl";
  inherit version src;

  postPatch = ''
    cp -r --reflink=auto ${goDeps} src/wrapper/vendor
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
    go_1_23
    wrapQtAppsHook
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    kguiaddons
    ki18n
    kirigami
    kirigami-addons
    knotifications
    kwindowsystem
    nlohmann_json
    qqc2-desktop-style
    qtbase
    qtdeclarative
    qtsvg
    qtwayland
  ];

  meta = with lib; {
    description = "GUI to monitor and manage Tailscale on your Linux desktop";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = platforms.unix;
  };
}
