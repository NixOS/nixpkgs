{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  tree-sitter,
  versionCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ripwire";
  version = "0.5.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "redhat-et";
    repo = "ripwire";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JB2xwEfDhljHo9tpxmpDkIFvjBdLwkhe7w2KnNrcN+Q=";
  };

  # Unvendor tree-sitter
  postPatch = ''
    rm -r third_party/deps/tree_sitter
    mkdir -p third_party/deps/tree_sitter
    ln -s ${tree-sitter.src}/lib third_party/deps/tree_sitter/lib
  '';

  nativeBuildInputs = [
    cmake
  ];

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    prependToVar cmakeFlags "-DCMAKE_C_COMPILER_AR=$(command -v $AR)"
    prependToVar cmakeFlags "-DCMAKE_C_COMPILER_RANLIB=$(command -v $RANLIB)"
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  buildInputs = [
    tree-sitter
  ];

  hardeningDisable = [ "format" ]; # -Werror=format-security

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The ripgrep of AI context: a zero-dependency C++23 CLI + MCP server giving coding agents a ranked, deterministic map of any repo, blast radius, tests-to-run and quality deltas. Signatures at 80% fewer bytes than bodies; ~5% of a grep-and-read pass's tokens";
    homepage = "https://github.com/redhat-et/ripwire";
    changelog = "https://github.com/redhat-et/ripwire/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "ripwire";
    platforms = lib.platforms.all;
  };
})
