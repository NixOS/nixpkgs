{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  pkg-config,
  sqlite,
  nix-update-script,
}:

let
  # capsule-engine embeds files from the Go tree of its repository, which
  # Cargo has for a git dependency but the vendored crate lacks. The same
  # revision as in Cargo.lock.
  capsuleEngineSrc = fetchFromGitHub {
    owner = "action-state-group";
    repo = "capsule-engine";
    rev = "c7701385b87b68c631803e5d0adeee4d617ff5d4";
    hash = "sha256-AHd0VQVv0UUKWBOr1pzIj+8rSk0v5+zpp/q9WkgM0Jk=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mesh-llm-capsules-plugin";
  version = "0.1.22";

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "capsules-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qhVeyd2pqKPeeJUdohT3ZEXCWHoe/fVslnBOPby/ym8=";
  };

  cargoRoot = "crates/evidence-plugin";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-VvhI6qerUHJVJEhjLVWQRpFaokfeEo4mOdVzbAdmyy0=";

  __structuredAttrs = true;

  # The mesh-llm-plugin this release pins runs a prebuilt protoc even when
  # PROTOC is set (mesh-llm-plugin uses PROTOC since Mesh-LLM/mesh-llm#2448).
  # Drop with the capsules release that has https://github.com/Mesh-LLM/capsules-plugin/pull/310.
  postPatch = ''
    substituteInPlace "$cargoDepsCopy"/*/mesh-llm-plugin-*/build.rs \
      --replace-fail 'unsafe { std::env::set_var("PROTOC", protoc) };' \
                     'if std::env::var_os("PROTOC").is_none() { unsafe { std::env::set_var("PROTOC", protoc) }; }'
    # capsule-engine's Go tree, see capsuleEngineSrc.
    grep -qF '${capsuleEngineSrc.rev}' ${finalAttrs.cargoRoot}/Cargo.lock \
      || { echo "capsuleEngineSrc.rev is not the capsule-engine in Cargo.lock" >&2; exit 1; }
    engine=$(echo "$cargoDepsCopy"/*/capsule-engine-*)
    cp -r ${capsuleEngineSrc}/go "$engine/../../go"
  '';

  env.PROTOC = lib.getExe' buildPackages.protobuf "protoc";

  # rusqlite's libsqlite3-sys finds SQLite through pkg-config.
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ sqlite ];

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Compares with Apple's codesign, which the build environment doesn't have.
    "--skip=producer::runtime_attest::tests::measure_self_produces_real_os_measured_matching_codesign_ground_truth"
  ];

  passthru = {
    # The name the plugin reports to the host, which must match its [[plugin]] entry.
    pluginName = "capsules";
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Signed, hash-chained exchange audit logs for MeshLLM";
    homepage = "https://github.com/Mesh-LLM/capsules-plugin";
    changelog = "https://github.com/Mesh-LLM/capsules-plugin/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kleinbem ];
    mainProgram = "capsules";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
