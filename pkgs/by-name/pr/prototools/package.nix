{
  fetchFromGitHub,
  installShellFiles,
  lib,
  nix-update-script,
  protobuf,
  python3Packages,
  runCommand,
  rustPlatform,
  stdenv,
  symlinkJoin,
  versionCheckHook,
}:

let
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "ThalesGroup";
    repo = "prototools";
    tag = "prototext-v${version}";
    hash = "sha256-svaczYXGQSMfKyEf30xRJl+UroXDFuJ9yL/AH5UBhU4=";
  };

  # Pre-compiled .pb fixture files required by prototext-core's build script.
  # Shared between the Rust (prototext) and Python (prototext-codec) builds to
  # avoid duplicating the protoc invocations and keep them in sync.
  fixtures = runCommand "prototools-fixtures" { nativeBuildInputs = [ protobuf ]; } ''
    mkdir -p $out
    # Compile all well-known types into a single descriptor set with
    # --include_imports so the embedded descriptor pool covers exactly the same
    # types as the WKT scoring graph (wkt/SOURCES).  If wkt/SOURCES changes
    # upstream, this list must be updated in sync.
    protoc \
      --descriptor_set_out=$out/descriptor.pb \
      --proto_path=${protobuf}/include \
      --include_imports \
      google/protobuf/any.proto \
      google/protobuf/api.proto \
      google/protobuf/descriptor.proto \
      google/protobuf/duration.proto \
      google/protobuf/empty.proto \
      google/protobuf/field_mask.proto \
      google/protobuf/source_context.proto \
      google/protobuf/struct.proto \
      google/protobuf/timestamp.proto \
      google/protobuf/type.proto \
      google/protobuf/wrappers.proto
    protoc \
      --descriptor_set_out=$out/knife.pb \
      --proto_path=${src}/prototext/fixtures/schemas \
      knife.proto
    protoc \
      --descriptor_set_out=$out/enum_collision.pb \
      --proto_path=${src}/prototext/fixtures/schemas \
      enum_collision.proto
    protoc \
      --descriptor_set_out=$out/message_set.pb \
      --proto_path=${src}/prototext/fixtures/schemas \
      message_set.proto
  '';

  prototext = rustPlatform.buildRustPackage {
    pname = "prototext";
    inherit version src;

    cargoRoot = ".";

    cargoHash = "sha256-c4HxWaAaMygeUbJL9xlt80H486NTcVWHP3NeWDqXGVc=";

    cargoBuildFlags = [
      "-p"
      "prototext"
    ];
    cargoTestFlags = [
      "-p"
      "prototext"
    ];

    # Disable the default features:
    # - "protox" would embed a protoc binary and attempt network access.
    # - The default wkt-db path would invoke reproto (not available here).
    # Re-enable wkt-db via "prebuilt-wkt", which copies wkt/prebuilt/*.rkyv
    # committed to the repository — no reproto needed.
    buildNoDefaultFeatures = true;
    buildFeatures = [
      "wkt-db"
      "prebuilt-wkt"
    ];

    nativeBuildInputs = [
      installShellFiles
    ];

    patchPhase = ''
      runHook prePatch
      mkdir -p prototext/fixtures/prebuilt
      cp ${fixtures}/descriptor.pb     prototext/fixtures/prebuilt/
      cp ${fixtures}/knife.pb          prototext/fixtures/prebuilt/
      cp ${fixtures}/enum_collision.pb prototext/fixtures/prebuilt/
      cp ${fixtures}/message_set.pb    prototext/fixtures/prebuilt/
      runHook postPatch
    '';

    postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd prototext \
        --bash <(PROTOTEXT_COMPLETE=bash $out/bin/prototext) \
        --zsh  <(PROTOTEXT_COMPLETE=zsh  $out/bin/prototext) \
        --fish <(PROTOTEXT_COMPLETE=fish $out/bin/prototext)
      # prototext-gen-man calls create_dir_all internally; no mkdir needed.
      # SOURCE_DATE_EPOCH and LC_ALL ensure reproducible man page output.
      SOURCE_DATE_EPOCH=0 LC_ALL=C $out/bin/prototext-gen-man $out/share/man/man1
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    passthru = {
      updateScript = nix-update-script { };
      inherit src version fixtures;
    };

    meta = {
      description = "Lossless protobuf <-> enhanced textproto converter";
      longDescription = ''
        Command-line tool for converting protobuf binary wire format to and
        from an enhanced textproto representation, with lossless round-trip.
        Supports automatic schema inference for Well-Known Types without a
        .proto file.
      '';
      homepage = "https://github.com/ThalesGroup/prototools";
      changelog = "https://github.com/ThalesGroup/prototools/releases/tag/prototext-v${version}";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ douzebis ];
      mainProgram = "prototext";
      platforms = lib.platforms.unix;
    };
  };

in
symlinkJoin {
  name = "prototools-${version}";
  strictDeps = true;
  __structuredAttrs = true;
  paths = [
    prototext
    python3Packages.protoscan
  ];
  passthru = {
    inherit src version fixtures;
  };
  meta = prototext.meta // {
    description = "Protocol Buffer utilities: prototext and protoscan CLIs";
    mainProgram = "prototext";
  };
}
