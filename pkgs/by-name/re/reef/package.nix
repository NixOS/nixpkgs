{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "reef";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "ZStud";
    repo = "reef";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FP7cnqYIICb4JCYk9ytvSp4yxW+xW2SUVqhELdTGLZQ=";
  };

  cargoHash = "sha256-UmazwJqsWXQK3bniDLyNCLXHrgrF3iHRPugOAkRzhv8=";

  postInstall = ''
    install -Dm644 fish/functions/*.fish -t $out/share/fish/vendor_functions.d/
    install -Dm644 fish/conf.d/reef.fish -t $out/share/fish/vendor_conf.d/
  '';

  nativeCheckInputs = [ versionCheckHook ];
  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bash compatibility layer for fish shell";
    homepage = "https://github.com/ZStud/reef";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nadir-ishiguro ];
    mainProgram = "reef";
    platforms = lib.platforms.unix;
  };
})
