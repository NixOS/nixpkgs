{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dasel";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${version}";
    sha256 = "sha256-DPfahZIb6Cp+E5GxIqNW+IruDZWBvJTRc7gxQOfeJqA=";
  };

  vendorHash = "sha256-+3RcjOZjmYu4eNpgczwY4Uyz1+poYA/TXc2Mb+VwRKc=";

  ldflags = [
    "-s" "-w" "-X github.com/tomwright/dasel/v2/internal.Version=${version}"
  ];

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
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
