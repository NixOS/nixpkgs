{
  lib,
  fetchFromGitHub,
  rustPlatform,
  notmuch,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mujmap";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "elizagamedev";
    repo = "mujmap";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Qb9fEPQrdn+Ek9bdOMfaPIxlGGpQ9RfQZOeeqoOf17E=";
  };

  cargoHash = "sha256-LyiJYKhoSXVf1P+nu56Wgp+z8biPpt0tWgPZQrB2NNQ=";

  buildInputs = [
    notmuch
  ];

  meta = {
    description = "JMAP integration for notmuch mail";
    homepage = "https://github.com/elizagamedev/mujmap/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ elizagamedev ];
    mainProgram = "mujmap";
  };
})
