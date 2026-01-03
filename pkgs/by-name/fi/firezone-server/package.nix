{
  lib,
  nixosTests,
  fetchFromGitHub,
  beamPackages,
  gitMinimal,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  tailwindcss_3,
  esbuild,
}:
beamPackages.mixRelease rec {
  pname = "firezone-server";
  version = "0-unstable-2025-12-31";

  src = "${
    fetchFromGitHub {
      owner = "firezone";
      repo = "firezone";
      rev = "96ca73bf827339cdae2258cf64230fd0407f29f6";
      hash = "sha256-ip648m9aC5xXJmz29nuCePSTnTMJeZGhybaV1ykTRpo=";

      # This is necessary to allow sending mails via SMTP, as the default
      # SMTP adapter is current broken: https://github.com/swoosh/swoosh/issues/785
      postFetch = ''
        ${lib.getExe gitMinimal} -C $out apply ${./0000-add-mua.patch} ${./0001-remove-hardcoded-domain-config.patch}
      '';
    }
  }/elixir";

  pnpmDeps = fetchPnpmDeps {
    inherit pname version src;
    pnpm = pnpm_9;
    sourceRoot = "elixir/assets";
    fetcherVersion = 1;
    hash = "sha256-3gv+0KjB1Xcsr1zUrzmWmeTSLtgz+FcqSlXtsf4hzjU=";
  };
  pnpmRoot = "assets";

  preBuild = ''
    cat >> config/config.exs <<EOF
    config :tailwind, path: "${lib.getExe tailwindcss_3}"
    config :esbuild, path: "${lib.getExe esbuild}"
    config :portal, run_manual_migrations: true
    EOF

    cat >> config/runtime.exs <<EOF
    config :tzdata, :data_dir, System.fetch_env!("TZDATA_DIR")
    EOF
  '';

  postBuild = ''
    # New firezone structure - no longer an umbrella app
    # Assets are in portal_web application
    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, assets.deploy
    mix do deps.loadpaths --no-deps-check, phx.digest
  '';

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_9
    nodejs
  ];

  mixReleaseName = "portal";

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}-${version}";
    inherit src version;
    hash = "sha256-MlY8TO+tqaq8kpOYfxpwvLAvdrUJqnmKiZ6+MOzcGB0=";
  };

  passthru.tests = {
    inherit (nixosTests) firezone;
  };

  meta = {
    description = "Backend server for the Firezone zero-trust access platform";
    homepage = "https://github.com/firezone/firezone";
    license = lib.licenses.elastic20;
    maintainers = with lib.maintainers; [
      oddlama
      patrickdag
    ];
    mainProgram = "portal";
    platforms = lib.platforms.linux;
  };
}
