{ lib
, vscode-utils
, useLocalExtensions ? false
}:
# Note that useLocalExtensions requires that vscode-server is not running
# on host. If it is, you'll need to remove $HOME/.vscode-server,
# and redo the install by running "Connect to host" on client

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  nodeVersion = "16";

  # As VS Code executes this code on the remote machine
  # we test to see if we can build Node from Nixpkgs
  # otherwise we check if the globally installed Node
  # is usable.
  patch = ''
    # Use Node from nixpkgs for NixOS hosts
    #

    serverDir="$HOME/.vscode-server/bin/$COMMIT_ID"
    serverNode="$serverDir/node"
    echo "VS Code Node: $serverNode"

    # Check if VS Code Server has a non-working Node or the wrong version of Node
    if ! nodeVersion=$($serverNode -v) || [ "\''${nodeVersion:1:2}" != "${nodeVersion}" ]; then
      echo "VS Code Node Version: $nodeVersion"

      if nix-build "<nixpkgs>" -A nodejs-${nodeVersion}_x --out-link "$serverDir/nix" && [ -e "$serverDir/nix/bin/node" ]; then
        nodePath="$serverDir/nix/bin/node"
      fi

      echo "Node from Nix: $nodePath"

      nodeVersion=$($nodePath -v)
      echo "Node from Nix Version: $nodeVersion"

      if [ "\''${nodeVersion:1:2}" != "${nodeVersion}" ]; then
        echo "Getting Node from Nix failed, use Local Node instead"
        nodePath=$(which node)
        echo "Local Node: $nodePath"
        nodeVersion=$($nodePath -v)
        echo "Local Node Version: $nodeVersion"
      fi

      if [ "\''${nodeVersion:1:2}" == "${nodeVersion}" ]; then
        echo PATCH: replacing $serverNode with $nodePath
        ln -sf $nodePath $serverNode
      fi
    fi

    nodeVersion=$($serverNode -v)
    echo "VS Code Node Version: $nodeVersion"

    if [ "\''${nodeVersion:1:2}" != "${nodeVersion}" ]; then
      echo "Unsupported VS Code Node version: $nodeVersion", quitting
      fail_with_exitcode ''${o.InstallExitCode.ServerTransferFailed}
    fi

    ${lib.optionalString useLocalExtensions ''
      # Use local extensions
      if [ -d $HOME/.vscode/extensions ]; then
        if [ -e $HOME/.vscode-server/extensions ]; then
          mv $HOME/.vscode-server/extensions $HOME/.vscode-server/extensions.bak
        fi

        mkdir -p $HOME/.vscode-server
        ln -s $HOME/.vscode/extensions $HOME/.vscode-server/extensions
      fi
    ''}

    #
    # Start the server
  '';
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "remote-ssh";
    publisher = "ms-vscode-remote";
    version = "0.78.0";
    sha256 = "sha256-vd+9d86Z8429QpQVCZm8gtiJDcMpD++aiFVwvCrPg5w=";
  };

  postPatch = ''
    substituteInPlace "out/extension.js" \
      --replace '# Start the server\n' '${patch}'
  '';

  meta = with lib; {
    description = "Use any remote machine with a SSH server as your development environment.";
    license = licenses.unfree;
    maintainers = with maintainers; [ SuperSandro2000 tbenst ];
  };
}
