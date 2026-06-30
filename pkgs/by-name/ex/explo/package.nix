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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "LumePart";
    repo = "Explo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EKYn2FE99H44Apxx8LTV794CRtdJR82o32oTh3qg5+w=";
  };

  webui = buildNpmPackage {
    inherit (finalAttrs)
      pname
      version
      src
      meta
      ;

    sourceRoot = "${finalAttrs.src.name}/src/web/frontend";

    npmDepsHash = "sha256-MIZqj7eWKOBMX9iw7P8Xd/nRFqi+F9iLBvgTVnvt6Mo=";

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

  vendorHash = "sha256-DUs3rkDtna6vLjFwNzVdfeUeo3UTGbMf2buXAcJLJwE=";

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

  __structuredAttrs = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--subpackage"
      "webui"
    ];
  };

  meta = {
    description = "Spotify's \"Discover Weekly\" for self-hosted music systems";
    homepage = "https://github.com/LumePart/Explo/";
    changelog = "https://github.com/${finalAttrs.src.owner}/${finalAttrs.src.repo}/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      arunoruto
      lilacious
    ];
    mainProgram = "explo";
  };
})
