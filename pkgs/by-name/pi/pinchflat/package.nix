{
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  beamPackages,
  sqlite,
  yarn,
  nodejs,
  esbuild,
  tailwindcss,
  fixup-yarn-lock,
  apprise,
  nix-update-script,
  yt-dlp,
}:
beamPackages.mixRelease rec {
  pname = "pinchflat";
  version = "2025.9.26";
  src = fetchFromGitHub {
    owner = "kieraneglin";
    repo = "pinchflat";
    rev = "v${version}";
    hash = "sha256-45lw/48WTlfwTMWsCryNY3g3W9Ff31vMvw0W9znAJGk=";

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
    hash = "sha256-7zLlOzBJcvookYX/4SNC0O1Yr62LIKH9R8rONl3diSs=";
  };
  removeCookie = false;

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = "${src}/assets/yarn.lock";
    sha256 = "sha256-xJL+qcohtu+OmZ31E1QU9uqBWAFGejKIO3XRd+R6z/4=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    tailwindcss
    yarn
  ];
  buildInputs = [ nodejs ];

  postBuild = ''
    export HOME=$PWD
    fixup-yarn-lock ~/assets/yarn.lock
    yarn --cwd assets config --offline set yarn-offline-mirror $yarnOfflineCache
    yarn --cwd assets install --offline --frozen-lockfile --ignore-engines --ignore-scripts --no-progress
    patchShebangs ~/assets/node_modules

    # phoenixframework expects platform-specific tailwind/esbuild binaries in a specific location:
    # https://github.com/phoenixframework/tailwind/blob/194ab0f979782e4ccf2fe796042bf8e20967df93/lib/tailwind.ex#L243-L251
    targets="linux-x64 linux-arm64 macos-x64 macos-arm64"
    for target in $targets; do
      ln -s "${tailwindcss}/bin/tailwindcss" "_build/tailwind-$target"
      ln -s "${esbuild}/bin/esbuild" "_build/esbuild-$target"
    done

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
    description = "Your next YouTube media manager";
    homepage = "https://github.com/kieraneglin/pinchflat";
    changelog = "https://github.com/kieraneglin/pinchflat/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ charludo ];
    platforms = lib.platforms.unix;
    mainProgram = "pinchflat";
  };
}
