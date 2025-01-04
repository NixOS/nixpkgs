{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGo123Module,
  cmake,
  extra-cmake-modules,
  git,
  go_1_23,
  wrapQtAppsHook,
  qtbase,
  qtdeclarative,
  qtsvg,
  qtwayland,
  kconfig,
  kcoreaddons,
  kguiaddons,
  ki18n,
  kirigami,
  kirigami-addons,
  knotifications,
  nlohmann_json,
  qqc2-desktop-style,
}:

let
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-nxYgpIUNgWhWnrd5rqSH2r1QKhWPJwxlIQl6F9PmjpU=";
  };

  goDeps =
    (buildGo123Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-UjgHfR+MJ8ROqOPIM0ZkqgFGVEkw8gKYlVQ6oxoIcgE=";
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
    qtbase
    qtdeclarative
    qtsvg
    qtwayland
    kconfig
    kcoreaddons
    kguiaddons
    ki18n
    kirigami
    kirigami-addons
    knotifications
    nlohmann_json
    qqc2-desktop-style
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
