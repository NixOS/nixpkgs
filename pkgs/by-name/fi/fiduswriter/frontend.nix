{
  lib,
  stdenv,
  fiduswriter,
  fetchPnpmDeps,

  gettext,
  nodejs,
  pnpmConfigHook,
  pnpm_11,
  python3,
  rsync,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fiduswriter-frontend";
  inherit (fiduswriter)
    version
    src
    ;
  __structuredAttrs = true;

  postPatch = fiduswriter.postPatch or "" + ''
    # Upstream uses a `package.json5` file for multiple components, each with
    # its own dependencies. To merge all of them into a single `package.json`
    # and get the associated lockfile, run: `python manage.py npm_install`
    mkdir -p fiduswriter/.transpile
    cp --no-preserve=mode ${./pnpm-lock.yaml} fiduswriter/.transpile/pnpm-lock.yaml
    cp --no-preserve=mode ${./package.json} fiduswriter/.transpile/package.json
    # (for fetchPnpmDeps)
    cp fiduswriter/.transpile/* .
  '';

  outputs = [
    "out"
    "node_modules"
  ];

  pnpmRoot = "fiduswriter/.transpile";
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      postPatch
      ;
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-8JqolPCb9HtfCIgRfM5a3BGozh4alYmEWuWSBUykAZg=";
  };

  nativeBuildInputs = [
    gettext
    nodejs
    pnpmConfigHook
    pnpm_11
    python3
    rsync
  ];

  env.PYTHONPATH = "${fiduswriter.passthru.pythonPath}";

  preBuild = ''
    pushd fiduswriter || true
    cp configuration-default.py configuration.py
    python manage.py setup # migrations, npm install, transpilation
    python manage.py collectstatic
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r fiduswriter/static-* $out

    mkdir -p $node_modules
    cp -r fiduswriter/.transpile/node_modules $node_modules

    runHook postInstall
  '';

  meta = {
    inherit (fiduswriter.meta)
      description
      homepage
      changelog
      license
      maintainers
      teams
      ;
  };
})
