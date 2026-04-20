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
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "always-further";
    repo = "nono";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/bKquUbVMM1e/YPcuSb0vW4tX/3yNDUxmaBWHKFw+Qs=";
  };
  cargoHash = "sha256-ibGIpH6Ls9nxtF6rRl+dZBbbmVRXDQA6vpPI/jzpDqI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # panics with "Deny-within-allow overlap on Linux ... Landlock cannot enforce this. ..."
    # landlock is linux only
    "--skip=policy::tests::test_all_groups_no_deny_within_allow_overlap"
    # panics with "exact-path fallback must not recursively cover descendants"
    "--skip=capability_ext::tests::test_from_profile_allow_file_falls_back_to_exact_directory_when_present"

    # env_vars
    # don't work inside of the /nix dir
    # unsure why home is still under /nix with writableTmpDirAsHomeHook
    # Sandbox initialization failed: Refusing to grant '/nix' (source: group:system_read_macos) because it overlaps protected nono state root '/nix/build/nix-<ID>/.home/.nono'.
    "--skip=allow_net_overrides_profile_external_proxy"
    "--skip=cli_flag_overrides_env_var"
    "--skip=env_nono_allow_comma_separated"
    "--skip=env_nono_block_net"
    "--skip=env_nono_block_net_accepts_true"
    "--skip=env_nono_network_profile"
    "--skip=env_nono_profile"
    "--skip=env_nono_upstream_bypass_comma_separated"
    "--skip=env_nono_upstream_proxy"
    "--skip=legacy_env_nono_net_block_still_works"
  ];

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
