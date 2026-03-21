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
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "googleworkspace";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yirGdRHIexO9I0KLyU5jnNqWUG7Xw/iQ0F93SkkzNi0=";
  };

  cargoHash = "sha256-M9uflVP8J7vRPYoBZ9GE/aq7nj6dFJa636HQrvR3nXs=";

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
