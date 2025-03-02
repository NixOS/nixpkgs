{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeWrapper,
  udev,
  systemd,
  btrfs-progs,
  cloud-utils,
  cryptsetup,
  e2fsprogs,
  util-linux,
  xfsprogs,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hot-resize";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "hot-resize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uWPO+nUuA9REWLBLCOOO/T7QiSc5b5EPKH1N5N2KnC4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-u+VW5aZkMhQ+dgRAHmK7avxp6PfzFyG49SfYr0stpuQ=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    udev
    systemd.dev
  ];

  PKG_CONFIG_PATH = "${systemd.dev}/lib/pkgconfig";

  postInstall = ''
    wrapProgram $out/bin/hot-resize \
      --prefix PATH : ${
        lib.makeBinPath [
          btrfs-progs
          cloud-utils
          cryptsetup
          e2fsprogs
          udev
          util-linux
          xfsprogs
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Tool for hot resizing disk partitions and filesystems without rebooting";
    homepage = "https://github.com/liberodark/hot-resize";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ liberodark ];
    platforms = lib.platforms.linux;
    mainProgram = "hot-resize";
  };
})
