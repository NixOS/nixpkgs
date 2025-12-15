{
  lib,
  nixosTests,
  fetchFromGitHub,
  beamPackages,
  gitMinimal,
  pnpm_9,
  nodejs,
  tailwindcss_3,
  esbuild,

  mixReleaseName ? "domain", # "domain" "web" or "api"
}:

beamPackages.mixRelease rec {
  pname = "firezone-server-${mixReleaseName}";
  version = "0-unstable-2025-08-31";

  src = "${
    fetchFromGitHub {
      owner = "firezone";
      repo = "firezone";
      rev = "f86719db19b848ab757995361032c1f2b7927d13";
      hash = "sha256-YvPxLEE6pdILrABWCZs7ebf6i3Inm1k/YkotZgI7A2k=";

      # This is necessary to allow sending mails via SMTP, as the default
      # SMTP adapter is current broken: https://github.com/swoosh/swoosh/issues/785
      postFetch = ''
        ${lib.getExe gitMinimal} -C $out apply ${./0000-add-mua.patch}
      '';
    }
  }/elixir";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version;
    src = "${src}/apps/web/assets";
    fetcherVersion = 1;
    hash = "sha256-40vtQIBhJNnzdxkAOVAcPN57IuD0IB6LFxGICo68AbQ=";
  };
  pnpmRoot = "apps/web/assets";

  preBuild = ''
    cat >> config/config.exs <<EOF
    config :tailwind, path: "${lib.getExe tailwindcss_3}"
    config :esbuild, path: "${lib.getExe esbuild}"
    EOF

    cat >> config/runtime.exs <<EOF
    config :tzdata, :data_dir, System.fetch_env!("TZDATA_DIR")
    EOF
  '';

  postBuild = ''
    pushd apps/web
    # for external task you need a workaround for the no deps check flag
    # https://github.com/phoenixframework/phoenix/issues/2690
    mix do deps.loadpaths --no-deps-check, assets.deploy
    mix do deps.loadpaths --no-deps-check, phx.digest priv/static
    popd
  '';

  nativeBuildInputs = [
    pnpm_9
    pnpm_9.configHook
    nodejs
  ];

  inherit mixReleaseName;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}-${version}";
    inherit src version;
    hash = "sha256-h3l7HK9dxNmkHWfJyCOCXmCvFOK+mZtmszhRv0zxqoo=";
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
    mainProgram = mixReleaseName;
    platforms = lib.platforms.linux;
  };
}
