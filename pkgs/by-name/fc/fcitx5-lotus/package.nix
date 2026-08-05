{
  lib,
  stdenv,
  acl,
  buildGoModule,
  cmake,
  fcitx5,
  fetchFromGitHub,
  gettext,
  go,
  hicolor-icon-theme,
  kdePackages,
  libinput,
  libx11,
  nix-update-script,
  pkg-config,
  python3,
  qt6,
  udev,
}:

let
  pythonEnv = python3.withPackages (
    ps: with ps; [
      dbus-python
      pyqt6
      qtpy
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-lotus";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "LotusInputMethod";
    repo = "fcitx5-lotus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-MN83U0/o+vDGCxpYgFxfXAf+Iw59OaXyB7770ppLmEQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gettext
    go
    hicolor-icon-theme
    kdePackages.extra-cmake-modules
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    acl
    fcitx5
    kdePackages.extra-cmake-modules
    libinput
    libx11
    pythonEnv
    qt6.qtbase
    udev
  ];

  strictDeps = true;
  __structuredAttrs = true;

  dontWrapQtApps = true;

  vendorDir =
    (buildGoModule {
      pname = "fcitx5-lotus-go-modules";
      inherit (finalAttrs) version src;
      modRoot = "bamboo";
      vendorHash = "sha256-HjVMGil4bNMTFifxFYtHELdkeKhrumHGrde4msbxvJc=";
    }).goModules;

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH=$TMPDIR/go

    rm -rf bamboo/vendor
    cp -r $vendorDir bamboo/vendor
  '';

  postPatch = ''
    substituteInPlace src/lotus-monitor.cpp \
      --replace-fail 'strcmp(exe_path, "/usr/bin/fcitx5-lotus-server") == 0' \
                     '(strncmp(exe_path, "/nix/store/", 11) == 0 && strlen(exe_path) >= 24 && strcmp(exe_path + strlen(exe_path) - 24, "/bin/fcitx5-lotus-server") == 0)'

    substituteInPlace server/lotus-server.cpp \
      --replace-fail 'strcmp(exe_path, "/usr/bin/fcitx5") == 0' \
                     '(strncmp(exe_path, "/nix/store/", 11) == 0 && strlen(exe_path) >= 11 && strcmp(exe_path + strlen(exe_path) - 11, "/bin/fcitx5") == 0)'
  '';

  postInstall = ''
    substituteInPlace $out/lib/udev/rules.d/99-lotus.rules \
      --replace-fail "/usr/bin/setfacl" "${acl}/bin/setfacl"

    substituteInPlace $out/lib/systemd/system/fcitx5-lotus-server@.service \
      --replace-fail "/usr/bin/setfacl" "${acl}/bin/setfacl" \
      --replace-fail "/usr/bin/fcitx5-lotus-server" "$out/bin/fcitx5-lotus-server"
  '';

  postFixup = ''
    patchShebangs $out/share/fcitx5-lotus/settings-gui
    wrapQtApp $out/bin/fcitx5-lotus-settings
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Vietnamese input method engine for Fcitx5";
    homepage = "https://github.com/LotusInputMethod/fcitx5-lotus";
    license = with lib.licenses; [
      gpl3Plus
      lgpl21Plus
    ];
    maintainers = with lib.maintainers; [ imcvampire ];
    platforms = lib.platforms.linux;
  };
})
