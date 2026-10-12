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

python3Packages.buildPythonApplication (
  finalAttrs:
  let
    # The four libraries reproto needs are private to it: built from the same
    # source, at the same version, with the same vendored Cargo dependencies
    # (passthru.cargoDeps), so that one update moves all five, and nothing
    # else in nixpkgs uses them.
    libraries =
      let
        shared = {
          inherit (finalAttrs) src version;
          inherit (finalAttrs.passthru) cargoDeps;
        };
      in
      {
        fdp-scan = python3Packages.callPackage ./fdp-scan.nix shared;
        prototext-codec = python3Packages.callPackage ./prototext-codec.nix shared;
        prototext-graph = python3Packages.callPackage ./prototext-graph.nix shared;
        tree-sitter-textproto = python3Packages.callPackage ./tree-sitter-textproto.nix {
          inherit (finalAttrs) src version;
        };
      };
  in
  {
    pname = "reproto";
    version = "0.3.3";
    pyproject = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "douzebis";
      repo = "prototools";
      tag = "v${finalAttrs.version}";
      hash = "sha256-SDgv/vrm7mJs1fjKPsn5zrp9s7rDj3W5qPdNt5OU/PE=";
    };

    sourceRoot = "${finalAttrs.src.name}/reproto";

    build-system = [ python3Packages.setuptools ];

    nativeBuildInputs = [ installShellFiles ];

    dependencies =
      with python3Packages;
      [
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
      ]
      ++ builtins.attrValues libraries;

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

    postInstall = ''
      installShellCompletion --cmd reproto --bash src/reproto/completions.sh
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      REPROTO_GEN_MAN=$out/share/man/man1 $out/bin/reproto
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];

    # versionCheckHook checks mainProgram; the package's other program too.
    postInstallCheck = ''
      $out/bin/reproto-instantiate-schema --version | grep -F ${finalAttrs.version}
    '';

    pythonImportsCheck = [ "reproto" ];

    passthru = {
      # The libraries' vendored Cargo dependencies: the source's Cargo.lock.
      cargoDeps = rustPlatform.fetchCargoVendor {
        inherit (finalAttrs) pname version src;
        hash = "sha256-DXbYSztud6x+xWDM2dgwkHr88p1MtBR+122Jxe8axls=";
      };
      inherit libraries;
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
  }
)
