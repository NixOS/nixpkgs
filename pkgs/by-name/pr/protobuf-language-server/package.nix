{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (final: {
  pname = "protobuf-language-server";
  version = "0.1.1-unstable-2025-05-21";

  src = fetchFromGitHub {
    owner = "lasorda";
    repo = "protobuf-language-server";
    rev = "ecab27467944346fb4227f90161d3ec823346646";
    hash = "sha256-hN91/yBcybF/4syItD1B03/qlR4cICYJQ3NNjIDBOrs=";
  };

  vendorHash = "sha256-4nTpKBe7ekJsfQf+P6edT/9Vp2SBYbKz1ITawD3bhkI=";

  # Exclude the example binary from being built
  excludedPackages = [ "./go-lsp/example" ];

  postPatch = ''
    # Fix the generate function in methods_gen_test.go to include proper imports
    substituteInPlace go-lsp/lsp/methods_gen_test.go \
      --replace-fail 'pkg := "// code gen by methods_gen_test.go, do not edit!\npackage lsp\n"' \
      'pkg := "// code gen by methods_gen_test.go, do not edit!\npackage lsp\n\nimport (\n\t\"context\"\n\n\t\"github.com/lasorda/protobuf-language-server/go-lsp/jsonrpc\"\n\t\"github.com/lasorda/protobuf-language-server/go-lsp/lsp/defines\"\n)\n"'
  '';

  meta = with lib; {
    description = "A language server implementation for Google Protocol Buffers";
    homepage = "https://github.com/lasorda/protobuf-language-server";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ olk ];
    platforms = platforms.all;
  };
})
