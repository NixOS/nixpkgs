{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
  cacert,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cfait";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.disroot.org";
    owner = "trougnouf";
    repo = "cfait";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y5O6+bsfoNC52+YTgptfH8Rv7IORN/m2MwzXh39ofXk=";
  };

  cargoHash = "sha256-t+Ppfw+Zx1fXOksm9IXxrvR6Qoy9bhuEVGtcwrTwD00=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  nativeCheckInputs = [ cacert ];

  meta = {
    description = "Fast, offline-first CalDAV and local task manager";
    homepage = "https://git.disroot.org/trougnouf/cfait";
    changelog = "https://git.disroot.org/trougnouf/cfait/src/tag/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ JorySeverijnse ];
    mainProgram = "cfait";
  };
})
