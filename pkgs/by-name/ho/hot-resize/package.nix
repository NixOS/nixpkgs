{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  makeWrapper,
  btrfs-progs,
  cryptsetup,
  e2fsprogs,
  util-linux,
  xfsprogs,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hot-resize";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "liberodark";
    repo = "hot-resize";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8UA5Wv96PUerBRTwTwkSAv1iw6lt9nd4MXGdKUmxoz4=";
  };

  cargoHash = "sha256-uGMd9xZRYbCJyHkUZXvUnN3M5N1FTaROfoww+oODAHE=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/hot-resize \
      --prefix PATH : ${
        lib.makeBinPath [
          btrfs-progs
          cryptsetup
          e2fsprogs
          util-linux
          xfsprogs
        ]
      }
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
