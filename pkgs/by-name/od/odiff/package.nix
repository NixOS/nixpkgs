{
  lib,
  stdenv,
  installShellFiles,
  fetchFromGitHub,
  zig_0_15,
  callPackage,
  versionCheckHook,
  nasm,
}:

let
  zig = zig_0_15;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "odiff";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "dmtrKovalenko";
    repo = "odiff";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lPpqVsWJ9LMgVLbDGbGfG/TZ+wb1qzUr7aZtuB/lFZc=";
  };

  postPatch = ''
    ln -s ${callPackage ./build.zig.zon.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    installShellFiles
    zig.hook
    nasm
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://github.com/dmtrKovalenko/odiff";
    description = "SIMD-first image comparison library";
    changelog = "https://github.com/dmtrKovalenko/odiff/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ddogfoodd ];
    platforms = lib.platforms.linux;
    mainProgram = "odiff";
  };
})
