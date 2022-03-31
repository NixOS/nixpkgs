{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dasel";
  version = "1.24.1";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = "dasel";
    rev = "v${version}";
    sha256 = "sha256-B6MWoGYNjFBUxnSqAXt2DRRjSlmgbqIC7qEoMFGQ+zU=";
  };

  vendorSha256 = "sha256-NP+Is7Dxz4LGzx5vpv8pJOJhodAYHia1JXYfhJD54as=";

  ldflags = [
    "-s" "-w" "-X github.com/tomwright/dasel/internal.Version=${version}"
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    if [[ "$("$out/bin/${pname}" --version)" == "${pname} version ${version}" ]]; then
      echo "" | $out/bin/dasel put object -p yaml -t string -t int "my.favourites" colour=red number=3 | grep -q red
      echo '${pname} smoke check passed'
    else
      echo '${pname} smoke check failed'
      return 1
    fi
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
