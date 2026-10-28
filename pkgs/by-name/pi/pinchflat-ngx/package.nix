{
  apprise,
  beamPackages,
  esbuild,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup-yarn-lock,
  lib,
  nix-update-script,
  nodejs,
  sqlite,
  tailwindcss_4,
  yarn,
  yt-dlp,
}:
beamPackages.mixRelease rec {
  pname = "pinchflat-ngx";
  version = "2026.10.20";

  src = fetchFromGitHub {
    owner = "TheBadFella";
    repo = "Pinchflat-NGX";
    tag = version;
    hash = "sha256-B48H/7WdURt/YIo4C4NvrHp+TtFuheJ523S5kJlZA9o=";
  };

  # force compile exqlite using our version
  env = {
    EXQLITE_USE_SYSTEM = "1";
    EXQLITE_SYSTEM_CFLAGS = "-I${sqlite.dev}/include";
    EXQLITE_SYSTEM_LDFLAGS = "-L${sqlite.out}/lib -lsqlite3";
  };

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-deps-${pname}";
    inherit src version;
    hash = "sha256-d6QNGBakyoeOrMZFIUkedacOY4porClARdM5swVX2fc=";
  };
  removeCookie = false;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/assets/yarn.lock";
    hash = "sha256-m842N1+CcCw8mgyH+zZdIcyAr4tcCrKFwTJwmfHHOyw=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    yarn
  ];
  buildInputs = [ nodejs ];

  postPatch = ''
    substituteInPlace config/config.exs --replace-fail 'config :esbuild,' 'config :esbuild, path: "${lib.getExe esbuild}",'
    substituteInPlace config/config.exs --replace-fail 'config :tailwind,' 'config :tailwind, path: "${lib.getExe tailwindcss_4}",'
  '';

  postBuild = ''
    export HOME=$PWD
    fixup-yarn-lock ~/assets/yarn.lock
    yarn --cwd assets config --offline set yarn-offline-mirror $yarnOfflineCache
    yarn --cwd assets install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs ~/assets/node_modules

    mix do deps.loadpaths --no-deps-check, tailwind default --minify + esbuild default --minify + phx.digest
  '';
  postInstall = ''
    wrapProgram $out/bin/pinchflat --prefix PATH : ${
      lib.makeBinPath [
        apprise
        yt-dlp
      ]
    }
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Enhanced, self-hosted YouTube media manager built on Pinchflat with Material 3 AMOLED UI, PostgreSQL support, OIDC SSO, and disk staging";
    homepage = "https://github.com/TheBadFella/Pinchflat-NGX";
    changelog = "https://github.com/TheBadFella/Pinchflat-NGX/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      adamcstephens
      charludo
    ];
    platforms = beamPackages.erlang.meta.platforms;
    mainProgram = "pinchflat";
  };
}
