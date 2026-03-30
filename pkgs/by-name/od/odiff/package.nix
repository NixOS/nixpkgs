{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  zig_0_15,
  versionCheckHook,
  nasm,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "odiff";
  version = "4.3.2";

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "odiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gCF+CInczBJfDyZgxEQor5C/OSxKciCu9gbZanaE/nA=";
  };

  nativeBuildInputs = [
    installShellFiles
    zig
    nasm
  ];

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gfZJhsd7p+CsYMN9Xepel4jxnDNhRwYRtkUAAf4TAnI=";
  };

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/dmtrKovalenko/odiff";
    description = "SIMD-first image comparison library";
    changelog = "https://github.com/dmtrKovalenko/odiff/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ddogfoodd ];
    platforms = (lib.platforms.linux ++ lib.platforms.darwin);
    mainProgram = "odiff";
  };
})
