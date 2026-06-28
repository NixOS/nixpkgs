{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "prosemirror-rs";
  version = "0.5.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fiduswriter";
    repo = "prosemirror-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Jw7074y39egW8P4p0Tx4UA5upbsy4zM3vrjf+NJsNLE=";
  };

  cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

  sourceRoot = "${finalAttrs.src.name}/python";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the https://prosemirror.net model / transform API in Rust";
    homepage = "https://github.com/fiduswriter/prosemirror-rs";
    mainProgram = "prosemirror-rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
