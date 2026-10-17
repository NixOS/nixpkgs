{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  nodejs_24,
  versionCheckHook,
  zig_0_15,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation rec {
  pname = "codex-auth";
  version = "0.2.8";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Loongphy";
    repo = "codex-auth";
    rev = "v${version}";
    hash = "sha256-J1aq5ieWkHqze4HF/7Lw+VIa+FxO7vmsXaDJc7VH+Wk=";
  };

  nativeBuildInputs = [
    zig
    makeWrapper
  ]
  ++ lib.optional (zig ? hook) zig.hook;

  dontUseZigBuild = true;
  dontUseZigCheck = true;
  dontAddPrefix = true;

  zigInstallFlags = [
    "-Doptimize=ReleaseSafe"
    "--prefix"
    (builtins.placeholder "out")
  ];

  postInstall = ''
    wrapProgram $out/bin/codex-auth \
      --prefix PATH : ${lib.makeBinPath [ nodejs_24 ]}
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "CLI for switching and managing Codex accounts";
    homepage = "https://github.com/Loongphy/codex-auth";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ richienb ];
    mainProgram = "codex-auth";
    platforms = lib.platforms.unix;
  };
}
