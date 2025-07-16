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
  version = "0-unstable-2025-03-15";

  src = "${
    fetchFromGitHub {
      owner = "firezone";
      repo = "firezone";
      rev = "09fb5f927410503b0d6e7fc6cf6a2ba06cb5a281";
      hash = "sha256-1CZBFhOwX0DfXykPQ9tzn4tHg2tSnByXEPtlZleHK5k=";

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
    hash = "sha256-ejyBppFtKeyVhAWmssglbpLleOnbw9d4B+iM5Vtx47A=";
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
    hash = "sha256-2Y9u5+o8+RG+c8Z6V7Vex5K1odI7a/WYj5fC0xWbVRo=";
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
