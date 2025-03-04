{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  typescript,
  esbuild,
  makeWrapper,
  nodejs,
}:
buildNpmPackage rec {
  pname = "opcua-commander";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "node-opcua";
    repo = "opcua-commander";
    rev = version;
    hash = "sha256-7KYwIdrhlvGR9RHZBfMFOcBa+opwx7Q/crCdvwZD6Y8=";
  };

  npmDepsHash = "sha256-g4WFLh+UnziQR2NZ4eL84Vrk+Mz99kFQiBkdGmBEMHE=";
  nativeBuildInputs = [
    esbuild
    typescript
    makeWrapper
  ];

  postPatch =
    let
      esbuildPrefix =
        "esbuild"
        # Workaround for 'No loader is configured for ".node" files: node_modules/fsevents/fsevents.node'
        # esbuild issue is https://github.com/evanw/esbuild/issues/1051
        + lib.optionalString stdenv.hostPlatform.isDarwin " --external:fsevents";
    in
    ''
      substituteInPlace package.json \
        --replace-fail 'npx -y esbuild' '${esbuildPrefix}'
    '';

  # We need to add `nodejs` to PATH for `opcua-commander` to properly work
  # when connected to an OPC-UA server.
  # Test it with:
  # ./opcua-commander -e opc.tcp://opcuademo.sterfive.com:26543
  postFixup = ''
    wrapProgram $out/bin/opcua-commander \
      --prefix PATH : "${lib.makeBinPath [ nodejs ]}"
  '';

  meta = with lib; {
    description = "Opcua client with blessed (ncurses)";
    homepage = "https://github.com/node-opcua/opcua-commander";
    license = licenses.mit;
    maintainers = with maintainers; [ jonboh ];
    mainProgram = "opcua-commander";
  };
}
