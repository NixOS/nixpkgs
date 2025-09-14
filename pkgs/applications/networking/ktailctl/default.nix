{
  buildGo124Module,
  cmake,
  extra-cmake-modules,
  fetchFromGitHub,
  git,
  go_1_24,
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
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-8k8TRJdfvlYkp3lfGRm8LeWhRuZnSHFZ7UwICRMjwds=";
  };

  goDeps =
    (buildGo124Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-/D06cfLWJ0T0FKXMFV7mPi13ag3tX2Pq9eELuERKHtY=";
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
    go_1_24
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
