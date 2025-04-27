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

    prettier --check ${./..}

    if [ $? -ne 0 ]; then
      cat <<EOF
    Error: `prettier` command failed. Please make sure the documentation is correctly formatted.

    Run this command from the Nixpkgs repository root for automatic formatting:

        prettier --write ${toString ./..}

    EOF
      exit 1
    fi

    touch "$out"
  ''
