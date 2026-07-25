{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  zig_0_15,
  versionCheckHook,
  nasm,
  nix-update-script,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "odiff";
  version = "4.3.8";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "odiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YiyhhVV73XfVoYCRcYU7PL+Vrcwaf2FINH0W+Ejcu4Q=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-gfZJhsd7p+CsYMN9Xepel4jxnDNhRwYRtkUAAf4TAnI=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    installShellFiles
    zig
    nasm
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

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
