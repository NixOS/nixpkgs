{
  runCommand,
  nodePackages,
  nixfmt-rfc-style,
}:

runCommand "manual_check-formatting"
  {
    nativeBuildInputs = [
      nodePackages.prettier
      nixfmt-rfc-style
    ];
  }
  ''
    set +e

    pushd ${./..}

    prettier --check .

    if [ $? -ne 0 ]; then
      cat <<EOF
    Error: `prettier` command failed. Please make sure the documentation is correctly formatted.

    Run these commands from the Nixpkgs repository root for automatic formatting:

        cd doc/
        prettier --write .

    EOF
      exit 1
    fi

    touch "$out"
  ''
