{ lib, stdenv, fetchurl, makeWrapper, nodejs }:

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

  meta = with lib; {
    description = "CLI tools for napi-rs";
    mainProgram = "napi";
    homepage = "https://napi.rs";
    license = licenses.mit;
    maintainers = with maintainers; [ winter ];
    inherit (nodejs.meta) platforms;
  };
}
