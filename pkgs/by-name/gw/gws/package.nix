{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
  apple-sdk_14,
  darwinMinVersionHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gws";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "googleworkspace";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vRBW7RUwHHAvAiF8WahkRh0pH205UiuJloY0DgFwLM=";
  };

  cargoHash = "sha256-tIJikoRFbUYYlkOjfWoPogoB+yhY80TTtSzEXgSEP8A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    lib.optionals stdenv.hostPlatform.isLinux [ dbus ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      apple-sdk_14
      (darwinMinVersionHook "10.15")
    ];

  doCheck = false;

  meta = {
    description = "One CLI for all of Google Workspace";
    homepage = "https://github.com/googleworkspace/cli";
    changelog = "https://github.com/googleworkspace/cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "gws";
    maintainers = with lib.maintainers; [ imalison ];
  };
})
