{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mithril";
  version = "0.1.3";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nmatt0";
    repo = "mithril";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GsJFTsW34e1W4b+zBmy9XfY2y/eGdsg0YANZAd733i4=";
  };

  nativeBuildInputs = [ cmake ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IoT firmware identification and extraction";
    homepage = "https://github.com/nmatt0/mithril";
    changelog = "https://github.com/nmatt0/mithril/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "mithril";
  };
})
