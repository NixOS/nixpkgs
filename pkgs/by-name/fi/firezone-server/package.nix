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
  version = "0-unstable-2025-02-17";

  src = "${
    fetchFromGitHub {
      owner = "firezone";
      repo = "firezone";
      rev = "7ea17c144a98780600cd8c40c4d5b6b344f9d917";
      hash = "sha256-GNwmrFm+sc7IDIyKvCm0OOyiY99wbBzUEBECLamW1Qs=";

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
    hash = "sha256-2G/6RnWzTV7zK2OT/kLIxcRZiWMvZavx6guk5t+zH4I=";
  };
  pnpmRoot = "apps/web/assets";

  preBuild = ''
    cat >> config/config.exs <<EOF
    config :tailwind, path: "${lib.getExe tailwindcss_3}"
    config :esbuild, path: "${lib.getExe esbuild}"
    EOF

    cat >> config/runtime.exs <<EOF
    config :tzdata, :data_dir, System.get_env("TZDATA_DIR")
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
    hash = "sha256-nR5sR3m9ZWsGiwLwvoT3dtIDKTrWi5VkwcT1r5cozrc=";
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
