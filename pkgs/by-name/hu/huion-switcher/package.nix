{
  lib,
  nix-update-script,
  fetchFromGitHub,
  rustPlatform,
  udev,
  pkg-config,
  installShellFiles,
  udevCheckHook,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "huion-switcher";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "whot";
    repo = "huion-switcher";
    tag = finalAttrs.version;
    hash = "sha256-+cMvBVtJPbsJhEmOh3SEXZrVwp9Uuvx6QmUCcpenS20=";
  };

  buildInputs = [ udev ];
  nativeBuildInputs = [
    pkg-config
    installShellFiles
    udevCheckHook
  ];

  cargoHash = "sha256-yj55FMdf91ZG95yuMt3dQFhUjYM0/sUfFKB+W+5xEfo=";

  postInstall = ''
    mv huion-switcher.{man,1}
    installManPage huion-switcher.1

    # Install 80-huion-switcher.rules

    # Mind the trailing space! We leave the args to huion-switcher in place
    substituteInPlace "80-huion-switcher.rules" --replace-fail \
      "IMPORT{program}=\"huion-switcher " \
      "IMPORT{program}=\"$out/bin/huion-switcher "

    install -Dm 0644 -t "$out/lib/udev/rules.d" "80-huion-switcher.rules"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to switch Huion devices into raw tablet mode";
    homepage = "https://github.com/whot/huion-switcher";
    changelog = "https://github.com/whot/huion-switcher/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    mainProgram = "huion-switcher";
    maintainers = with lib.maintainers; [ dramforever ];
  };
})
