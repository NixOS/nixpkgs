{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhai-doc";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rhaiscript";
    repo = "rhai-doc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GZq5C8Q95OHKftEkps4Y6X6sAc4pzSfSq3ELUW/kPWI=";
  };

  cargoHash = "sha256-Lk/vbYxBcK676qusl6mWO38RAkCuiyHwZLcJpcHrdO4=";

  meta = {
    description = "Tool to auto-generate documentation for Rhai source code";
    homepage = "https://github.com/rhaiscript/rhai-doc";
    changelog = "https://github.com/rhaiscript/rhai-doc/releases/tag/${finalAttrs.src.rev}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "rhai-doc";
  };
})
