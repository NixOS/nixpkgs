{
  lib,
  stdenv,
  installShellFiles,
  fetchFromTangled,
  zig_0_14,
  versionCheckHook,
}:

let
  zig = zig_0_14;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lsr";
  version = "1.0.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromTangled {
    did = "did:plc:7sufqp5jkgsrtsit7gd5wpo2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Te6GKPnW0XFliSjTI9UhkmT72AEmuUXfO7xNrV01mJk=";
  };

  zigDeps = zig.fetchDeps {
    inherit (finalAttrs) src pname version;
    hash = "sha256-lnOow40km0mcj21i2mTQiDGXLhcSxQ2kJoAgUhkQiEg=";
  };

  postConfigure = ''
    ln -s ${finalAttrs.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  nativeBuildInputs = [
    installShellFiles
    zig
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

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
