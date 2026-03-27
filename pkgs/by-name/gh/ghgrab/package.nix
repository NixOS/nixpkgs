{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
}:

# note: upstream has a flake
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ghgrab";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "abhixdd";
    repo = "ghgrab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-09+DI1/jKfcbPNB1rUyXtu642TuU7z9UBbQllg9uoQM=";
  };

  cargoHash = "sha256-9o5AQxe/G5Yc6T/Ogtvq1N32t2eM8jAKt6CIvNBzX70=";

  # fails on darwin
  # https://github.com/abhixdd/ghgrab/issues/31
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=agent_tree_invalid_url_returns_json_error"
  ];

  meta = {
    changelog = "https://github.com/abhixdd/ghgrab/releases/tag/v${finalAttrs.version}";
    description = "Simple, pretty terminal tool that lets you search and download files from GitHub without leaving your CLI";
    homepage = "https://github.com/abhixdd/ghgrab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "ghgrab";
  };
})
