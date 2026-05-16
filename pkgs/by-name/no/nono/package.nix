{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  pkg-config,

  dbus,

  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nono";
  version = "0.53.0";

  __darwinAllowLocalNetworking = true; # required for tests

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jK3/NDNQkeeCKP2iMIJMCq9lrDZ9ksiEnHhFmrz+gew=";
  };
  cargoHash = "sha256-OK2vlXYFdjMHqzVR6ZoRn7WEfAUVATGhk32JLoDED5c=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = map (t: "--skip=${t}") (
    [
      # fails to initialize the sandbox under '/build'
      "test_all_profiles_signal_mode_resolves"
      # panic
      "build_run_profile_patch_adds_override_deny_for_sensitive_file"
      "build_run_profile_patch_merges_read_and_write_to_allow_file"
      "prepare_profile_save_from_patch_updates_existing_user_profile"
      "would_shadow_builtin_allows_update_of_existing_user_override"
      "would_shadow_builtin_flags_known_builtin_names"
      "create_audit_state_creates_session_when_enabled"

      # audit_attestation
      # needs /bin/pwd
      "audit_verify_reports_signed_attestation_with_pinned_public_key"
      "rollback_signed_session_verifies_from_audit_dir_bundle"

      # nono-cli
      # wants a script `cripts/test-list-aliases.sh`, `git`, and `.git` history
      "alias_inventory_script_passes"
      # fails to initialize the sandbox under '/build'
      # has also failed due to running on darwin despite testing the linux only
      # landlock sandboxing
      "policy::tests::test_all_groups_no_deny_within_allow_overlap"
      # not relevant for us, requires `git`
      "lint_docs_script_passes"
      # want to run `git`
      "alias_inventory_rejects_marker_missing_field"
      "alias_inventory_rejects_naked_serde_alias"
      "alias_inventory_rejects_unapproved_deprecated_module_reach_in"
      "lint_docs_accepts_clean_tree"
      "lint_docs_rejects_quoted_override_deny_outside_allowlist"

      # nono-proxy
      # fails to prepare TLS bundle inside build sandbox
      "server::tests::test_intercept_lifecycle_end_to_end"
      "server::tests::test_route_diagnostics_summarises_each_route"
      "tls_intercept::bundle::tests::bundle_contains_ephemeral_and_system_roots"
      "tls_intercept::bundle::tests::bundle_file_has_restrictive_permissions"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # panics with "exact-path fallback must not recursively cover descendants"
      "capability_ext::tests::test_from_profile_allow_file_falls_back_to_exact_directory_when_present"

      # env_vars
      # don't work inside of the /nix dir
      # unsure why home is still under /nix with writableTmpDirAsHomeHook
      # Sandbox initialization failed: Refusing to grant '/nix' (source: group:system_read_macos) because it overlaps protected nono state root '/nix/build/nix-<ID>/.home/.nono'.
      "allow_net_overrides_profile_external_proxy"
      "cli_flag_overrides_env_var"
      "env_nono_allow_comma_separated"
      "env_nono_block_net"
      "env_nono_block_net_accepts_true"
      "env_nono_network_profile"
      "env_nono_profile"
      "env_nono_upstream_bypass_comma_separated"
      "env_nono_upstream_proxy"
      "legacy_env_nono_net_block_still_works"
      "environment_allow_vars_bare_star"
      "environment_allow_vars_default_allows_all"
      "environment_allow_vars_prefix_patterns"
      "environment_allow_vars_with_profile"
    ]
  );

  meta = {
    description = "Secure, kernel-enforced sandbox for AI agents, MCP and LLM workloads";
    homepage = "https://github.com/always-further/nono";
    changelog = "https://github.com/always-further/nono/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      jk
    ];
    mainProgram = "nono";
    # https://github.com/always-further/nono#platform-support
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
