{
  buildGo124Module,
  cmake,
  fetchFromGitHub,
  git,
  go_1_24,
  lib,
  nlohmann_json,
  stdenv,
  kdePackages,
}:

let
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    tag = "v${version}";
    hash = "sha256-mKkHp6ZRTTepg/wo/1jeWBERRezT6hz0EL3ZDlS7nGk=";
  };

  goDeps =
    (buildGo124Module {
      pname = "ktailctl-go-wrapper";
      inherit src version;
      modRoot = "src/wrapper";
      vendorHash = "sha256-RBjWTNbKS/nzD1tF28BZrBJPbx0s6t7Bi1eRFgtHYwk=";
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
    git
    go_1_24
  ]
  ++ (with kdePackages; [
    wrapQtAppsHook
    extra-cmake-modules
  ]);

  buildInputs =
    with kdePackages;
    [
      kconfig
      kcoreaddons
      kdbusaddons
      kguiaddons
      ki18n
      kirigami
      kirigami-addons
      knotifications
      kwindowsystem
      qtbase
      qtdeclarative
      qtsvg
      qtwayland
      qqc2-desktop-style
    ]
    ++ [
      nlohmann_json
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
