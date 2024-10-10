{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  npm-lockfile-fix,
}:

buildGoModule rec {
  pname = "beszel";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    rev = "refs/tags/v${version}";
    hash = "sha256-zToX6M6JqLnQ5YhHPjb30sijLVEs/H23zjrn6xLDDLM=";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/beszel/site/package-lock.json
    '';
  };

  webui = buildNpmPackage {
    inherit
      pname
      version
      src
      meta
      ;

    npmFlags = [ "--legacy-peer-deps" ];

    buildPhase = ''
      runHook preBuild

      node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';

    sourceRoot = "${src.name}/beszel/site";

    npmDepsHash = "sha256-CtcFjPgWz21SmeneQbl2XypGejeKcFseS76ds2eCWuk=";
  };

  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-1K3qxhu2ng1purHce83270hOJwm5WB114nVeldkhTlc=";

  preBuild = ''
    mkdir -p site/dist
    cp -r ${webui}/* site/dist
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/henrygd/beszel";
    changelog = "https://github.com/henrygd/beszel/releases/tag/v${version}";
    description = "Lightweight server monitoring hub with historical data, docker stats, and alerts";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    license = lib.licenses.mit;
  };
}
