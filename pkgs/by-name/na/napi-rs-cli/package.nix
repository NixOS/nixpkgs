{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "napi-rs-cli";
  version = "2.17.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@napi-rs/cli/-/cli-${version}.tgz";
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

<<<<<<< HEAD
  meta = {
    description = "CLI tools for napi-rs";
    mainProgram = "napi";
    homepage = "https://napi.rs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ winter ];
=======
  meta = with lib; {
    description = "CLI tools for napi-rs";
    mainProgram = "napi";
    homepage = "https://napi.rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    inherit (nodejs.meta) platforms;
  };
}
