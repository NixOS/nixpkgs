{
  lib,
  fetchFromCodeberg,
  installShellFiles,
  rustPlatform,
  stdenv,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keylights";
  version = "0.1.0";

  __structuredAttrs = true;

  src = fetchFromCodeberg {
    owner = "wjohnsto";
    repo = "keylights";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cl/IRkQMowrWOt0yLEFZC1J2MM6Fr68J6YaakUXwxTQ=";
  };

  cargoHash = "sha256-ns+EppqGP19P+xzevgZcovPKwYkMkWTcu5L0bovuQuk=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    keylightsBin="target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/keylights"

    "$keylightsBin" completions bash > keylights.bash
    "$keylightsBin" completions fish > keylights.fish
    "$keylightsBin" completions zsh > _keylights

    installShellCompletion --cmd keylights \
      --bash keylights.bash \
      --fish keylights.fish \
      --zsh _keylights
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
    command = "keylights --version";
  };

  meta = {
    description = "Daemonless CLI for discovering and controlling Elgato Key Light devices";
    homepage = "https://codeberg.org/wjohnsto/keylights";
    changelog = "https://codeberg.org/wjohnsto/keylights/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ wjohnsto ];
    mainProgram = "keylights";
    platforms = lib.platforms.linux;
  };
})
