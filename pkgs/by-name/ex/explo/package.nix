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
  version = "1.1.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "LumePart";
    repo = "Explo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wq5oU5AVgBYN3j/m7T07ZI16RF11orysXqjPbYKVd98=";
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
