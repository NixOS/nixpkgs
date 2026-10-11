{
  lib,
  zigStdenv,
  fetchFromGitHub,
  zig_0_15,
}:

zigStdenv.mkDerivation rec {
  __structuredAttrs = true;
  pname = "codex-auth";
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "Loongphy";
    repo = "codex-auth";
    rev = "v${version}";
    hash = "sha256-J1aq5ieWkHqze4HF/7Lw+VIa+FxO7vmsXaDJc7VH+Wk=";
  };

  nativeBuildInputs = [
    zig_0_15.hook
  ];

  strictDeps = true;

  meta = {
    description = "A CLI tool to switch and manage OpenAI Codex accounts";
    homepage = "https://github.com/Loongphy/codex-auth";
    changelog = "https://github.com/Loongphy/codex-auth/releases/tag/v${version}";
    license = lib.licenses.mit;

    maintainers = [ lib.maintainers.alyamanmas ];
    mainProgram = "codex-auth";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
