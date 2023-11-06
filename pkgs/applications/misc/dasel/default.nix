{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "dasel";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${version}";
    hash = "sha256-zxTT/CkSbH40R7itXAx0zD+haHOoMep/W4KfalJQ/8w=";
  };

  vendorHash = "sha256-CbR0uHtha2OoHW9mcB1I2lGJbjerbZARVN/mTstv/Y0=";

  ldflags = [
    "-s" "-w" "-X github.com/tomwright/dasel/v2/internal.Version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd dasel \
      --bash <($out/bin/dasel completion bash) \
      --fish <($out/bin/dasel completion fish) \
      --zsh <($out/bin/dasel completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    if [[ $($out/bin/dasel --version) == "dasel version ${version}" ]]; then
      echo '{ "my": { "favourites": { "colour": "blue" } } }' \
        | $out/bin/dasel put -t json -r json -t string -v "red" "my.favourites.colour" \
        | grep "red"
    else
      return 1
    fi
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Query and update data structures from the command line";
    longDescription = ''
      Dasel (short for data-selector) allows you to query and modify data structures using selector strings.
      Comparable to jq / yq, but supports JSON, YAML, TOML and XML with zero runtime dependencies.
    '';
    homepage = "https://github.com/TomWright/dasel";
    changelog = "https://github.com/TomWright/dasel/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    mainProgram = "dasel";
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
