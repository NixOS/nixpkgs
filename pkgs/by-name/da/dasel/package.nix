{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dasel";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${version}";
    hash = "sha256-oMc7AgEYJ4Qdw352A/xzpYIxfkSk+V+E5LWOHzAAjpo=";
  };

  vendorHash = "sha256-hdsrmrMfg+ZRLCCfXL4RJZOBQKfx5a+Xxz7i/SXwfaQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/tomwright/dasel/v3/internal.Version=${version}"
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    if [[ $($out/bin/dasel version) == "${version}" ]]; then
      echo '{ "my": { "favourites": { "colour": "blue" } } }' \
        | $out/bin/dasel query -i json -o json 'my.favourites.colour = "red"' \
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
    changelog = "https://github.com/TomWright/dasel/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "dasel";
    maintainers = with lib.maintainers; [ _0x4A6F ];
  };
}
