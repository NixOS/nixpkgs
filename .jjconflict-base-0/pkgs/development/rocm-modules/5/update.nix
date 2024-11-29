{ lib
, writeScript
}:

{ name ? ""
, owner ? ""
, repo ? ""
, page ? "releases/latest"
, filter ? ".tag_name | split(\"-\") | .[1]"
}:

let
  pname =
    if lib.hasPrefix "rocm-llvm-" name
    then "llvm.${lib.removePrefix "rocm-llvm-" name}"
    else name;

  updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    version="$(curl ''${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} \
      -sL "https://api.github.com/repos/${owner}/${repo}/${page}" | jq '${filter}' --raw-output)"

    IFS='.' read -a version_arr <<< "$version"

    if (( ''${version_arr[0]} > 5 )); then
      echo "'rocmPackages_5.${pname}' is already at it's maximum allowed version.''\nAny further upgrades should go into 'rocmPackages_X.${pname}'." 1>&2
      exit 1
    fi

    if [ "''${#version_arr[*]}" == 2 ]; then
      version="''${version}.0"
    fi

    update-source-version rocmPackages_5.${pname} "$version" --ignore-same-hash
  '';
in [ updateScript ]
