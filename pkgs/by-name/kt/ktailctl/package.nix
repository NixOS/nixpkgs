{
  buildGo127Module,
  cmake,
  fetchFromGitHub,
  git,
  go_1_27,
  lib,
  nix-update-script,
  nlohmann_json,
  stdenv,
  kdePackages,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.22.4";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    tag = "v${version}";
    hash = "sha256-MZlzzMy1unm3xWtkJhMBy3rE7g1dAUEBPk4CA/VpchM=";
  };

  goModules =
    (buildGo127Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/tailscale/wrapper";
      vendorHash = "sha256-MnaVaQ2rJDH2EwiuAJms+KdMde4T/js2Q8ktvDNYExg=";
    }).goModules;
in
stdenv.mkDerivation {
  pname = "ktailctl";
  inherit version src goModules;

  postPatch = ''
    cp -r --reflink=auto ${goModules} src/tailscale/wrapper/vendor
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
    writableTmpDirAsHomeHook
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

  passthru.updateScript = nix-update-script { };

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
