{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  xorg,
  pkg-config,
  gpgme,
  btrfs-progs,
}:
let
  version = "1.5";
in
buildGoModule {
  pname = "gomanagedocker";
  inherit version;

  src = fetchFromGitHub {
    owner = "ajayd-san";
    repo = "gomanagedocker";
    tag = "v${version}";
    hash = "sha256-y2lepnhaLsjokd587D0bCEd9cmG7GuNBbbx+0sKSCGA=";
  };

  vendorHash = "sha256-hUlv3i+ri9W8Pf1zVtFxB/QSdPJu1cWCjMbquCxoSno=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gpgme
    btrfs-progs
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  ldflags = [
    "-s"
    "-w"
  ];

  # Mocking of docker and podman containers fails
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "TUI tool to manage your docker images, containers and volumes";
    homepage = "https://github.com/ajayd-san/gomanagedocker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "gomanagedocker";
  };
}
