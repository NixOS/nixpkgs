{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "little_boxes";
  version = "1.14.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "giodamelio";
    repo = "little_boxes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JQrCKXN0yf9hQIbrdqmDFJs2f7tkxEWHqfqEisOinEc=";
  };

  cargoVendorDir = "vendor";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/little_boxes man > little_boxes.1
    installManPage little_boxes.1
    installShellCompletion --cmd little_boxes \
      --bash <($out/bin/little_boxes completions bash) \
      --fish <($out/bin/little_boxes completions fish) \
      --zsh <($out/bin/little_boxes completions zsh) \
      --nushell <($out/bin/little_boxes completions nushell)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Add boxes are input text";
    longDescription = ''
      little_boxes is a small program that takes input from stdin or a file
      and wraps it with box made of ACII/Unicode Box Drawing characters. There
      are several different charsets and you can optionally add a title

      Example:

      $ echo "Hello World" | little_boxes
      ┏━━━━━━━━━━━━━┓
      ┃ Hello World ┃
      ┗━━━━━━━━━━━━━┛
    '';
    homepage = "https://github.com/giodamelio/little_boxes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ giodamelio ];
    mainProgram = "little_boxes";
  };
})
