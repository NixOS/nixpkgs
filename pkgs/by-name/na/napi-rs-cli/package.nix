{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "napi-rs-cli";
  version = "2.17.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@napi-rs/cli/-/cli-${finalAttrs.version}.tgz";
    hash = "sha256-DeqH3pEtGZoKEBz5G0RfDO9LWHGMKL2OiWS1uWk4v44=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin" "$out/lib/napi-rs-cli"

    cp scripts/index.js "$out/lib/napi-rs-cli"

    makeWrapper ${nodejs}/bin/node "$out/bin/napi" --add-flags "$out/lib/napi-rs-cli/index.js"

    runHook postInstall
  '';

  meta = {
    description = "CLI tools for napi-rs";
    mainProgram = "napi";
    homepage = "https://napi.rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winter ];
    inherit (nodejs.meta) platforms;
  };
})
