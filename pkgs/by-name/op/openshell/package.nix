{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  cacert,
  gitMinimal,
  pkg-config,
  z3,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "openshell";
  version = "0.0.116";

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "OpenShell";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9YOAkBPFBOhvc3s/0jl0yphjwblONB6rTZXosIydCIg=";
  };

  cargoHash = "sha256-WVoB7tf1ZxjCo/4sRvKRy8yA0M+R+EjZVkbxr3LHGwQ=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [ z3 ];

  nativeCheckInputs = [
    cacert
    gitMinimal
  ];

  postPatch = ''
    # fill in package version to Cargo
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
    # only build openshell-cli crate in addition to the server and sandbox so that the vm-driver can be built.
    substituteInPlace Cargo.toml \
      --replace-fail 'members = ["crates/*"]' 'members = ["crates/openshell-cli", "crates/openshell-server", "crates/openshell-sandbox"]'
  '';

  env = {
    # docker image tag baked in at compile time, must match binary version
    OPENSHELL_IMAGE_TAG = finalAttrs.version;
  };

  doCheck = !stdenv.hostPlatform.isDarwin;

  checkFlags = [
    # This is coming additionally from the server.
    "--skip=inference::tests::managed_route_resolves_default_credential_handles"
    # These two need internet access to resolve google.
    "--skip=proxy::tests::test_forward_public_ip_allowed_without_allowed_ips"
    "--skip=proxy::tests::test_resolve_check_allowed_ips_rejects_outside_allowlist"
    # Stateful tests??
    "--skip=child_env::tests::apply_proxy_env_includes_node_proxy_opt_in_and_local_bypass"
    "--skip=child_env::tests::apply_tls_env_sets_node_and_bundle_paths"
    "--skip=process::tests::canonical_tty_environment_replaces_supervisor_identity_defaults"
    "--skip=process::tests::inject_provider_env_sets_placeholder_values"
    "--skip=process::tests::inject_provider_env_skips_supervisor_identity_material"
    "--skip=process::tests::strip_supervisor_only_env_removes_identity_material"
    "--skip=process::tests::validate_oci_workspace_rejects_unwritable_directory"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    changelog = "https://github.com/NVIDIA/OpenShell/releases/tag/v${finalAttrs.version}";
    description = "The safe, private runtime for autonomous AI agents.";
    homepage = "https://docs.nvidia.com/openshell/index.html";
    license = lib.licenses.asl20;
    longDescription = ''
      NVIDIA OpenShell is an open source runtime to build and deploy autonomous,
      self-evolving agents more safely. OpenShell sits between your agent and
      your infrastructure to govern how the agent executes, what the agent can
      see and do, and where inference goes. It enables claws to run in isolated
      sandboxes, with fine-grained control over privacy and security.
    '';
    maintainers = with lib.maintainers; [ wishstudio ];
    mainProgram = "openshell";
    platforms = lib.platforms.all;
  };
})
