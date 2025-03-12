{
  buildGo124Module,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
}:

buildGo124Module rec {
  pname = "beszel";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${version}";
    hash = "sha256-4RuYZcBR7X9Ug6l91N/FtyfT38HlW2guputzo4kF8YU=";
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

      npx lingui extract --overwrite
      npx lingui compile
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

    npmDepsHash = "sha256-UKOS7QyGsdKosjhxVhZErFkXhnfrFxdX0ozBUJGsNII=";
  };

  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-VX9mil0Hdmb85Zd9jfvm5Zz2pPQx+oAGHY+BI04bYQY=";

  preBuild = ''
    mkdir -p site/dist
    cp -r ${webui}/* site/dist
  '';

  postInstall = ''
    mv $out/bin/agent $out/bin/beszel-agent
    mv $out/bin/hub $out/bin/beszel-hub
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
