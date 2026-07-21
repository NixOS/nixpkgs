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
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    tag = "v${version}";
    hash = "sha256-BRkjVZaoxiMW8JltIkYDiCCE2kNGLDpRJd0iclQMcGY=";
  };

  goDeps =
    (buildGoModule {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/tailscale/wrapper";
      vendorHash = "sha256-h2gf9igVOguNRroGK6qvinUlEkpeZ2YJTtKArvlMj88=";
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
    changelog = "https://github.com/f-koehler/KTailctl/releases/tag/${src.tag}";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = lib.platforms.unix;
  };
}
