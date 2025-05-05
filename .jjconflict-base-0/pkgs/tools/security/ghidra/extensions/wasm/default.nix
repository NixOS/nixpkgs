{
  lib,
  fetchFromGitHub,
  buildGhidraExtension,
  ghidra,
  ant,
}:
let
  version = "2.3.1";
in
buildGhidraExtension {
  pname = "wasm";
  inherit version;

  src = fetchFromGitHub {
    owner = "nneonneo";
    repo = "ghidra-wasm-plugin";
    rev = "v${version}";
    hash = "sha256-aoSMNzv+TgydiXM4CbvAyu/YsxmdZPvpkZkYEE3C+V4=";
  };

  nativeBuildInputs = [ ant ];

  configurePhase = ''
    runHook preConfigure

    # this doesn't really compile, it compresses sinc into sla
    pushd data
    ant -f build.xml -Dghidra.install.dir=${ghidra}/lib/ghidra sleighCompile
    popd

    runHook postConfigure
  '';

  meta = {
    description = "Ghidra Wasm plugin with disassembly and decompilation support";
    homepage = "https://github.com/nneonneo/ghidra-wasm-plugin";
    downloadPage = "https://github.com/nneonneo/ghidra-wasm-plugin/releases/tag/v${version}";
    changelog = "https://github.com/nneonneo/ghidra-wasm-plugin/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.BonusPlay ];
  };
}
