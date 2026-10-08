{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
  xz,
  lz4,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "moria";
  version = "0.2.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nmatt0";
    repo = "moria";
    tag = "v${finalAttrs.version}";
    hash = "sha256-okeAzE2qUO6i1a4kyp+IjsH7OOyBCAMQv+dzgBR73o8=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    zlib
    xz
    lz4
    zstd
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "IoT firmware identification and extraction";
    homepage = "https://github.com/nmatt0/moria";
    changelog = "https://github.com/nmatt0/moria/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
    mainProgram = "moria";
  };
})
