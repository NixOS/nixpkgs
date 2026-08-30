{
  buildGo127Module,
  cmake,
  fetchFromGitHub,
  git,
  go_1_27,
  lib,
  nlohmann_json,
  stdenv,
  kdePackages,
}:

let
  version = "0.22.2";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    tag = "v${version}";
    hash = "sha256-FcWhetRUlIxZ3tdDyklxZ1ctQhE7IZao91xP0V3rjYA=";
  };

  goDeps =
    (buildGo127Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/tailscale/wrapper";
      vendorHash = "sha256-Skuff6OoeYHg8TxJAPuFNzN5G3tS21QBAc5WSEB3jk0=";
    }).goModules;
in
stdenv.mkDerivation {
  pname = "ktailctl";
  inherit version src;

  postPatch = ''
    cp -r --reflink=auto ${goDeps} src/tailscale/wrapper/vendor
  '';

  # needed for go build to work
  preBuild = ''
    export HOME=$TMPDIR
  '';

  cmakeFlags = [
    # actually just disables Go vendoring updates
    "-DKTAILCTL_FLATPAK_BUILD=ON"
  ];

  nativeBuildInputs = with kdePackages; [
    cmake
    extra-cmake-modules
    git
    go_1_27
    wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
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

  meta = {
    description = "GUI to monitor and manage Tailscale on your Linux desktop";
    changelog = "https://github.com/f-koehler/KTailctl/releases/tag/${src.tag}";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = lib.platforms.unix;
  };
}
