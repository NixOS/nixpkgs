{
  buzz-cli,
  lib,
  jq,
  runCommand,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-backend-kubernetes";
  # Shares the Buzz workspace source and Cargo lockfile with buzz-cli.
  inherit (buzz-cli)
    version
    src
    cargoHash
    preBuild
    env
    ;

  __structuredAttrs = true;
  strictDeps = true;

  cargoBuildFlags = [ "--package=buzz-backend-kubernetes" ];
  cargoTestFlags = [ "--package=buzz-backend-kubernetes" ];

  # `info` is the one request that needs no cluster: Buzz asks it for the
  # provider's protocol version and configuration form.
  passthru.tests.info =
    runCommand "buzz-backend-kubernetes-info"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          jq
        ];
      }
      ''
        echo '{"op":"info"}' | buzz-backend-kubernetes > reply.json
        jq -e '.ok and (.config_schema.properties.namespace | type == "object")' reply.json
        touch $out
      '';

  meta = {
    description = "Provider that runs Buzz remote agents as Kubernetes pods";
    homepage = "https://github.com/block/buzz";
    license = lib.licenses.asl20;
    mainProgram = "buzz-backend-kubernetes";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
