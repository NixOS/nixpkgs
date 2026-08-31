{
  lib,
  fetchurl,
  buildNpmPackage,
}:
buildNpmPackage (finalAttrs: {
  pname = "lgtv-ip-control-cli";
  version = "4.3.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/lgtv-ip-control-cli/-/lgtv-ip-control-cli-${finalAttrs.version}.tgz";
    hash = "sha256-4+yJ54q/vSNCCLxVYcPAtLsdtyeZ2x4ncxNkul81vfM=";
  };

  npmDepsHash = "sha256-7QL1LxZgzdyqs5BuWidEJQNVJh6t3BG8KMYDXY/iBfw=";

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 bin/lgtv-ip-control.cjs $out/bin/lgtv-ip-control
    cp -r dist $out/dist
    cp -r node_modules $out/node_modules
    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/WesSouza/lgtv-ip-control/blob/v${finalAttrs.version}/CHANGELOG.md";
    description = "Tool to provide network control for LG TVs manufactured since 2018";
    homepage = "https://github.com/WesSouza/lgtv-ip-control";
    license = with lib.licenses; [
      mit
    ];
    mainProgram = "lgtv-ip-control";
    maintainers = with lib.maintainers; [ fidgetingbits ];
  };
})
