{
  lib,
  stdenv,
  installShellFiles,
  fetchgit,
  zig_0_14,
  callPackage,
  versionCheckHook,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lsr";
  version = "1.0.0";

  src = fetchgit {
    url = "https://tangled.sh/@rockorager.dev/lsr";
    rev = "v${finalAttrs.version}";
    sparseCheckout = [
      "src"
      "docs"
    ];
    hash = "sha256-VeB0R/6h9FXSzBfx0IgpGlBz16zQScDSiU7ZvTD/Cds=";
  };

  postPatch = ''
    ln -s ${callPackage ./deps.nix { }} $ZIG_GLOBAL_CACHE_DIR/p
  '';

  nativeBuildInputs = [
    installShellFiles
    zig.hook
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    homepage = "https://tangled.sh/@rockorager.dev/lsr";
    description = "ls but with io_uring";
    changelog = "https://tangled.sh/@rockorager.dev/lsr/tags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ddogfoodd ];
    platforms = lib.platforms.linux;
    mainProgram = "lsr";
  };
})
