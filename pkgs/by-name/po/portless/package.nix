{
  lib,
  stdenv,
  fetchurl,
  nodejs_24,
  makeWrapper,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "portless";
  version = "0.15.5";

  src = fetchurl {
    url = "https://registry.npmjs.org/portless/-/portless-${finalAttrs.version}.tgz";
    hash = "sha256-92+3+NOQ1uCDaiXg+VShBmVCjqzUxy83CMqix7UEPS4=";
  };

  # npm tarballs extract under a "package/" subdirectory
  sourceRoot = "package";

  nativeBuildInputs = [ makeWrapper ];

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/portless" "$out/bin"
    cp -r dist package.json "$out/lib/portless/"
    makeWrapper "${lib.getExe nodejs_24}" "$out/bin/portless" \
      --add-flags "$out/lib/portless/dist/cli.js"
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Replace port numbers with stable, named .localhost URLs for local development";
    homepage = "https://portless.sh";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GuillaumeDesforges ];
    platforms = lib.platforms.linux;
    mainProgram = "portless";
  };
})
