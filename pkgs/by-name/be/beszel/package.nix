{
  buildGoModule,
  lib,
  fetchFromGitHub,
  nix-update-script,
  buildNpmPackage,
  fetchpatch,
}:

buildGoModule rec {
  pname = "beszel";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "henrygd";
    repo = "beszel";
    tag = "v${version}";
    hash = "sha256-tZLv/YwamQpZDo2Ha86z3lpDdLl7PVarBiAXJtCn1UE=";
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

    npmDepsHash = "sha256-ObLulUnCCcKetDW6XKdC8u0NuKBLVUl37jebCGloGoE=";
  };

  sourceRoot = "${src.name}/beszel";

  vendorHash = "sha256-h4JgRzjpG17kKXEchX+OtLBnjjd0C3D37jUCvOqQXP0=";

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
