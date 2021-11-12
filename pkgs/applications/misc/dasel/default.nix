{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "dasel";
  version = "1.21.2";

  src = fetchFromGitHub {
    owner = "TomWright";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-HHeO8mbvD+PLMKjeacjIBNEVeOYjeHjXJHhTkbMMOG4=";
  };

  vendorSha256 = "sha256-yP4iF3403WWgWAmBHiuOpDsIAUx4+KR8uKPfjy3qXt8=";

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
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ _0x4A6F ];
  };
}
