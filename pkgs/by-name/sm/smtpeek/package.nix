{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "smtpeek";
  version = "1.0.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "0xricksanchez";
    repo = "SMTPeek";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IIsy6MfyjrhuG/6AAYC7hnS/OBv32XPRaQ3L0IYozHM=";
  };

  cargoHash = "sha256-JowidHb7CPJQVFKFxhBgsObZdDd8Mp1FnATyJzXzb5k=";

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "SMTP user validation";
    homepage = "https://github.com/0xricksanchez/SMTPeek";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smtpeek";
  };
})
