{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rhai-doc";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "rhaiscript";
    repo = "rhai-doc";
    rev = "v${version}";
    hash = "sha256-GZq5C8Q95OHKftEkps4Y6X6sAc4pzSfSq3ELUW/kPWI=";
  };

  cargoHash = "sha256-Lk/vbYxBcK676qusl6mWO38RAkCuiyHwZLcJpcHrdO4=";

  meta = with lib; {
    description = "Tool to auto-generate documentation for Rhai source code";
    homepage = "https://github.com/rhaiscript/rhai-doc";
    changelog = "https://github.com/rhaiscript/rhai-doc/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
    mainProgram = "rhai-doc";
  };
}
