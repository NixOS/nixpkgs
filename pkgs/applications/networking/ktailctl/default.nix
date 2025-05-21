{ lib
, stdenv
, fetchFromGitHub
, buildGoModule
, cmake
, extra-cmake-modules
, git
, go
, wrapQtAppsHook
, qtbase
, qtdeclarative
, qtsvg
, qtwayland
, kconfig
, kcoreaddons
, kguiaddons
, ki18n
, kirigami
, kirigami-addons
, knotifications
, nlohmann_json
, qqc2-desktop-style
}:

let
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-jACcTRIdzYiSLy7zw5QuDu9tZfee9ufhlEecbTbSr+4=";
  };

  goDeps = (buildGoModule {
    pname = "ktailctl-go-wrapper";
    inherit src version;
    modRoot = "src/wrapper";
    vendorHash = "sha256-V4Bn5/VaoFOZlNGBedA4Ly8Kocw0BWyfIHv8IU6Eay4=";
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
    go
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
