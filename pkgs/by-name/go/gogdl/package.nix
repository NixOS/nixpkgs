{
  lib,
  writeScript,
  python3Packages,
  fetchFromGitHub,
  cacert,
}:

python3Packages.buildPythonApplication rec {
  pname = "gogdl";
  version = "1.1.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    rev = "1ff09820915f855ea764c6e49ea2def63e86b3bb";
    hash = "sha256-pK6JeTJeBq9qVfflNSYs3s4HuD0Kz6k9DDUVHL81FV0=";
  };

  disabled = python3Packages.pythonOlder "3.8";

  propagatedBuildInputs = with python3Packages; [
    setuptools
    requests
  ];

  pythonImportsCheck = [ "gogdl" ];

  meta = with lib; {
    description = "GOG Downloading module for Heroic Games Launcher";
    mainProgram = "gogdl";
    homepage = "https://github.com/Heroic-Games-Launcher/heroic-gogdl";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ iedame ];
  };

  # Upstream no longer create git tags when bumping the version, so we have to
  # extract it from the source code on the main branch.
  passthru.updateScript = writeScript "gogdl-update-script" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl gnused jq common-updater-scripts
    set -eou pipefail;

    owner=Heroic-Games-Launcher
    repo=heroic-gogdl
    path='gogdl/__init__.py'

    version=$(
      curl --cacert "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      https://raw.githubusercontent.com/$owner/$repo/main/$path |
      sed -n 's/^\s*version\s*=\s*"\([0-9]\.[0-9]\.[0-9]\)"\s*$/\1/p')

    commit=$(curl --cacert "${cacert}/etc/ssl/certs/ca-bundle.crt" \
      https://api.github.com/repos/$owner/$repo/commits?path=$path |
      jq -r '.[0].sha')

    update-source-version \
      ${pname} \
      "$version" \
      --file=./pkgs/games/gogdl/default.nix \
      --rev=$commit
  '';
}
