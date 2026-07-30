{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  zig_0_16,
  versionCheckHook,
  nasm,
  nix-update-script,
}:

let
  zig = zig_0_16;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "odiff";
  version = "4.5.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "odiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kUkt1N21ZuaXBuMFSrQbHgX2ItvSt8CIM3sT4d4bv5c=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    fetchAll = true;
    hash = "sha256-12dowp2dcZtvV7t2pZHgMMpywviAMZHFW1N6YG5uaXk=";
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
