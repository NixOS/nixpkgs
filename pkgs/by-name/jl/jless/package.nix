{
  lib,
  fetchFromGitHub,
  rustPlatform,
  stdenv,
  python3,
  libxcb,
}:

rustPlatform.buildRustPackage rec {
  pname = "jless";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "PaulJuliusMartinez";
    repo = "jless";
    rev = "v${version}";
    hash = "sha256-76oFPUWROX389U8DeMjle/GkdItu+0eYxZkt1c6l0V4=";
  };

  cargoHash = "sha256-moXZcPGh0+KyyeUMjH7/+hvF86Penk2o2DQWj4BEzt8=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ python3 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ libxcb ];

  meta = with lib; {
    description = "Command-line pager for JSON data";
    mainProgram = "jless";
    homepage = "https://jless.io";
    changelog = "https://github.com/PaulJuliusMartinez/jless/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      jfchevrette
    ];
  };
}
