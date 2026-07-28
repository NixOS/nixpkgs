{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "explo";
  version = "1.1.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LumePart";
    repo = "Explo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7FIDRNZn+Yh2c/oLU3Ggb4A9y+5q3vv17eVLmGR2Zeo=";
  };

  webui = buildNpmPackage {
    inherit (finalAttrs)
      pname
      version
      src
      meta
      ;

    sourceRoot = "${finalAttrs.src.name}/src/web/frontend";

    npmDepsHash = "sha256-N+i+VFHKJ9OxHyQKJ3vSw50N3tLjvFVPeG5aU0hLzqw=";

    buildPhase = ''
      runHook preBuild

      npx vite build --outDir dist

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r dist/* $out

      runHook postInstall
    '';
  };

  vendorHash = "sha256-pa3WaVJU4WY/EyE3VttfEVOwwaxvkfxQj0wrwOmefYQ=";

  ldflags = [
    "-X explo/src/config.Version=${finalAttrs.version}"
  ];

  preBuild = ''
    mkdir -p src/web/dist
    cp -r ${finalAttrs.webui}/* src/web/dist
  '';

  postInstall = ''
    mv $out/bin/main $out/bin/explo
    mkdir -p $out/share/explo
    cp src/downloader/youtube_music/search_ytmusic.py $out/share/explo/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "webui"
    ];
  };

  meta = {
    description = "Spotify's \"Discover Weekly\" for self-hosted music systems";
    homepage = "https://github.com/LumePart/Explo/";
    changelog = "https://github.com/LumePart/Explo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      lilacious
      arunoruto
    ];
    mainProgram = "explo";
  };
})
