{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dasel";
  version = "3.11.2";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-F7oNs65AsokIgYjaPqgSbtsZ5JwSFJ/A6Edm+LzQqgU=";
  };

  vendorHash = "sha256-oqGUHPnfCxgUTueB1zEJ8/h0L+2oxoVQHI+oJm3HcPo=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tomwright/dasel/v3/internal.Version=v${finalAttrs.version}"
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    if [[ $($out/bin/dasel version) == "${finalAttrs.version}" ]]; then
      echo '{ "my": { "favourites": { "colour": "blue" } } }' \
        | $out/bin/dasel -i json 'my.favourites.colour = "red"' \
        | grep "red"
    else
      return 1
    fi
    runHook postInstallCheck
  '';

  meta = {
    description = "Query and update data structures from the command line";
    longDescription = ''
      Dasel (short for data-selector) allows you to query and modify data structures using selector strings.
      Comparable to jq / yq, but supports JSON, YAML, TOML and XML with zero runtime dependencies.
    '';
    homepage = "https://github.com/TomWright/dasel";
    changelog = "https://github.com/TomWright/dasel/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "dasel";
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
})
