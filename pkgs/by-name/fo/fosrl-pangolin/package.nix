{
  lib,
  fetchFromGitHub,
  esbuild,
  buildNpmPackage,
}:

buildNpmPackage rec {
  pname = "pangolin";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "pangolin";
    tag = version;
    hash = "sha256-2yrim4pr8cgIh/FBuGIuK+ycwImpMiz+m21H5qYARmU=";
  };

  npmDepsHash = "sha256-fi4e79Bk1LC/LizBJ+EhCjDzLR5ZocgVyWbSXsEJKdw=";
  nativeBuildInputs = [ esbuild ];
  # fix the dependency on google fonts
  patches = [ ./dep.patch ];
  buildPhase = ''
    runHook preBuild
    npx drizzle-kit generate --dialect sqlite --schema ./server/db/schemas/ --out init
    npm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/

    cp package.json package-lock.json $out/

    cp -r .next/standalone/* $out/
    cp -r .next/standalone/.next $out/

    cp -r .next/static $out/.next/static
    cp -r dist $out/dist
    cp -r init $out/dist/init

    cp server/db/names.json $out/dist/names.json
    cp -r public $out/public
    cp -r node_modules $out/
    runHook postInstall
  '';

  meta = {
    description = "Self-hosted tunneled reverse proxy server with identity and access control, designed to securely expose private resources on distributed networks";
    homepage = "https://github.com/fosrl/pangolin";
    changelog = "https://github.com/fosrl/pangolin/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jackr ];
    platforms = lib.platforms.linux;
  };
}
