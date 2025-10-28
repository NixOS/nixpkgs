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
  version = "0.21.3";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-BKVq6d8CDmAOGULKoxXtlGbtgNu7wfsQnsyYV7PiFfc=";
  };

  goDeps =
    (buildGoModule {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-RhVZ1yXm+gJHM993Iw1XM/w/O1YiG6Mt4YMK+0JqRpg=";
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

  meta = with lib; {
    description = "GUI to monitor and manage Tailscale on your Linux desktop";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = platforms.unix;
  };
}
