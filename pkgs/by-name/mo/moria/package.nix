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
  version = "0.1.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nmatt0";
    repo = "moria";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tzBJEUl2AbzZh4exjlhw7yv4JsgTj80DYngoRofJjgY=";
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
