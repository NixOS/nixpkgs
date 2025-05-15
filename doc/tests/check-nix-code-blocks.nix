{
  runCommand,
  markdown-code-runner,
  nixfmt-rfc-style,
  ruff,
}:

runCommand "manual_check-nix-code-blocks"
  {
    nativeBuildInputs = [
      markdown-code-runner
      nixfmt-rfc-style
      ruff
    ];
  }
  ''
    set +e

    mdcr --check --config ${./mdcr-config.toml} ${./..}

    if [ $? -ne 0 ]; then
      cat <<EOF
    Error: `mdcr` command failed. Please make sure the Nix code snippets in Markdown files are correctly formatted.

    Run this command from the Nixpkgs repository root for automatic formatting:

        mdcr --log debug --config ${toString ./..}/tests/mdcr-config.toml ${toString ./..}

    EOF
      exit 1
    fi

    touch "$out"
  ''
