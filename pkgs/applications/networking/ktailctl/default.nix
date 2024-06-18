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
, kconfig
, kcoreaddons
, kguiaddons
, ki18n
, kirigami
, kirigami-addons
, knotifications
, nlohmann_json
}:

let
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "f-koehler";
    repo = "KTailctl";
    rev = "v${version}";
    hash = "sha256-fIx6XfNGK+jDpeaoCzTKwv3J01yWoHOgWxjbwTGVK1U=";
  };

  goDeps = (buildGoModule {
    pname = "tailwrap";
    inherit src version;
    modRoot = "tailwrap";
    vendorHash = "sha256-egTzSdOKrhdEBKarIfROxZUsxbnR9F1JDbdoKzGf9UM=";
  }).goModules;
in
stdenv.mkDerivation {
  pname = "ktailctl";
  inherit version src;

  postPatch = ''
    cp -r --reflink=auto ${goDeps} tailwrap/vendor
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
    kconfig
    kcoreaddons
    kguiaddons
    ki18n
    kirigami
    knotifications
    nlohmann_json
  ];

  meta = with lib; {
    description = "GUI to monitor and manage Tailscale on your Linux desktop";
    homepage = "https://github.com/f-koehler/KTailctl";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ k900 ];
    mainProgram = "ktailctl";
    platforms = platforms.all;
  };
}
