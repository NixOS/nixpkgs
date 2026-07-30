{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  python3,
  libxcb,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "jless";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${finalAttrs.version}";
    hash = "sha256-76oFPUWROX389U8DeMjle/GkdItu+0eYxZkt1c6l0V4=";
  };

  cargoHash = "sha256-moXZcPGh0+KyyeUMjH7/+hvF86Penk2o2DQWj4BEzt8=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ python3 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = {
    description = "Command-line pager for JSON data";
    mainProgram = "jless";
    homepage = "https://jless.io";
    changelog = "https://github.com/PaulJuliusMartinez/jless/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      jfchevrette
    ];
  };
})
