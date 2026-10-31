{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  protobuf,
  buf,
  prototext,
  versionCheckHook,

  # passthru
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "reproto";
  version = "0.3.6";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "douzebis";
    repo = "prototools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PTOmgGRMhMrss2HBwgLp7ub7uNVncNVkT63W+7wqk3U=";
  };

  sourceRoot = "${finalAttrs.src.name}/reproto";

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [
    click
    google-re2
    # The Python library. A bare `protobuf` would be the function argument
    # above, the top-level package that provides protoc for the tests:
    # `with` never shadows a function argument.
    python3Packages.protobuf
    pyvis
    pyyaml
    rapidfuzz
    rich
    tree-sitter
    # Built from this package's source, at its version, with the
    # vendored crates below: they move with it (python-modules).
    fdp-scan
    prototext-codec
    prototext-graph
    tree-sitter-textproto
  ];

  # The tests compile their fixtures with protoc, normalize the .proto
  # files they render with buf, and compare with prototext's decoding.
  nativeCheckInputs = [
    buf
    protobuf # protoc, the top-level package; not the Python library
    prototext
  ]
  ++ (with python3Packages; [
    pytest-xdist
    pytestCheckHook
    tree-sitter-language-pack
  ]);

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd reproto \
      --bash <(_REPROTO_COMPLETE=bash_source $out/bin/reproto) \
      --zsh <(_REPROTO_COMPLETE=zsh_source $out/bin/reproto) \
      --fish <(_REPROTO_COMPLETE=fish_source $out/bin/reproto)
    REPROTO_GEN_MAN=$out/share/man/man1 $out/bin/reproto
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];

  # versionCheckHook checks mainProgram; the package's other program too.
  postInstallCheck = ''
    $out/bin/reproto-instantiate-schema --version | grep -F ${finalAttrs.version}
  '';

  pythonImportsCheck = [ "reproto" ];

  passthru = {
    # The Rust libraries' vendored Cargo dependencies: the source's
    # Cargo.lock. fdp-scan, prototext-codec and prototext-graph take them
    # from here.
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      hash = "sha256-aHobnBJJWsMem2oehd8pNwlrXHdjnY/it20mGK9+N2s=";
    };
    # Only v-prefixed release tags
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Reconstruct .proto sources and schema databases from protobuf descriptors";
    longDescription = ''
      reproto turns compiled protobuf descriptor sets (.pb, or the
      descriptors protoscan finds in a binary) back into .proto source
      files, and builds the schema databases prototext and protolens use to
      decode messages without their original sources.
    '';
    homepage = "https://github.com/douzebis/prototools";
    changelog = "https://github.com/douzebis/prototools/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
    mainProgram = "reproto";
    platforms = lib.platforms.unix;
  };
})
