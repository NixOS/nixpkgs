{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  udev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "passless";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pando85";
    repo = "passless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tPlCiXokONUswwEDB2e23gR/NU6G+VYHgqfE+RyRsxw=";
  };

  cargoHash = "sha256-cNVmzK/W1jER6eK33JgFVnAN/6vGY4gw3GHB/H5DbIQ=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    udev
  ];

  postInstall = ''
    install -Dm644 contrib/udev/* $out/etc/udev/rules.d

    export COMPLETIONS="target/${stdenv.targetPlatform.config}/$cargoBuildType/build/passless-rs-*/out/completions"

    installShellCompletion --cmd passless \
      --bash $COMPLETIONS/passless.bash \
      --fish $COMPLETIONS/passless.fish \
      --zsh $COMPLETIONS/_passless
  '';

  meta = {
    homepage = "https://github.com/pando85/passless";
    description = "Virtual FIDO2 device and client FIDO 2 utility";
    changelog = "https://github.com/pando85/passless/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    mainProgram = "passless";
    maintainers = [ lib.maintainers.erictapen ];
    platforms = lib.platforms.linux;
  };

})
