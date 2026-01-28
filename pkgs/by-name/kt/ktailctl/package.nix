{
  buildGoModule,
  cmake,
  fetchFromGitHub,
  git,
  go,
  lib,
  nlohmann_json,
  stdenv,
  kdePackages,
}:

let
  version = "0.21.5";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-DqPerb8NcNynMMmoG8Ld0ZEyhrNg2q17TaErAbXIHC0=";
  };

  goDeps =
    (buildGoModule {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-jA1yortzyaBOP9GenmARhBBNDdpkGo9DNz0CXlh3BIU=";
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

  nativeBuildInputs = with kdePackages; [
    cmake
    extra-cmake-modules
    git
    go
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
    homepage = "https://github.com/f-koehler/KTailctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = lib.platforms.unix;
  };
}
