{
  lib,
  fetchFromGitHub,
  aws-lc,
  cacert,
  dbus,
  nix-update-script,
  pkg-config,
  rustPlatform,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  xz,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aurelia";
  version = "0.3.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Drackrath";
    repo = "Aurelia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WV/Mz9MBEkJNGL8Zz5nVzPOhT1IEtJ6HL3+uH5EdVkE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    aws-lc
    dbus
    xz
  ];

  cargoHash = "sha256-Z2FP0YdHwiTs91bG8B9HrCreQKMjpEEi7jyYuNT2WJ4=";

  nativeCheckInputs = [
    cacert
    writableTmpDirAsHomeHook
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  checkType = "debug";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Headless command-line Steam client";
    homepage = "https://github.com/Drackrath/Aurelia";
    changelog = "https://github.com/Drackrath/Aurelia/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.linux;
    mainProgram = "aurelia";
  };
})
