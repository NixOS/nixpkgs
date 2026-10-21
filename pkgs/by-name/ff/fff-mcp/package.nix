{
  fetchFromGitHub,
  lib,
  libgit2,
  pkg-config,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fff-mcp";
  version = "0.11.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "fff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GSjvvdLkuezFUrHqiSeePa64VRb3tabOKZNqEE5XSAw=";
  };

  cargoHash = "sha256-VKI7MnqCGis78qmYuBkViT96ZhG4Wy9vARdnmGV048A=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libgit2 ];

  env.LIBGIT2_NO_VENDOR = "1";

  # The workspace also holds a Neovim FFI crate, a C library and Python/Node
  # bindings; none of them are wanted here.
  cargoBuildFlags = [
    "--package"
    "fff-mcp"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # The parent-death watchdog only ticks fast enough to meet the test's 5s
  # deadline under `debug_assertions`; in a release build it ticks once a minute.
  checkFlags = [ "--skip=exits_when_parent_dies_even_without_idle_timeout" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  meta = {
    description = "MCP server for the fff file search engine";
    homepage = "https://github.com/dmtrKovalenko/fff";
    changelog = "https://github.com/dmtrKovalenko/fff/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "fff-mcp";
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})
