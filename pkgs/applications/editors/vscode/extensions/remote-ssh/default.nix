{ lib
, nixosTests
, vscode-utils
, useLocalExtensions ? false
}:
# Note that useLocalExtensions requires that vscode-server is not running
# on host. If it is, you'll need to remove $HOME/.vscode-server,
# and redo the install by running "Connect to host" on client

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

  # As VS Code executes this code on the remote machine
  # we test to see if we can build Node 14 from Nixpkgs
  # otherwise we use the local Node if it is version 14
  patch = ''
    d="$HOME/.vscode-server/bin/$COMMIT_ID"
    f="$d/node"
    echo "VS Code Node: $f"

    # Check if VS Code Server has a non-working Node or the wrong version of Node
    if ! nodeVersion=$($f -v) || [ "\''${nodeVersion:1:2}" != "14" ]; then
      echo "VS Code Node Version: $nodeVersion"

      if [ -e $(nix-build "<nixpkgs>" -A nodejs-14_x --out-link "$d/nix")/bin/node ]; then
        nodePath="$d/nix/bin/node"
      fi

      echo "Node from Nix: $nodePath"

      nodeVersion=$($nodePath -v)
      echo "Node from Nix Version: $nodeVersion"

      if [ "\''${nodeVersion:1:2}" != "14" ]; then
        echo "Getting Node from Nix failed, use Local Node instead"
        nodePath=$(which node)
        echo "Local Node: $nodePath"
        nodeVersion=$($nodePath -v)
        echo "Local Node Version: $nodeVersion"
      fi

      if [ "\''${nodeVersion:1:2}" == "14" ]; then
        echo PATCH: replacing $f with $nodePath
        rm $f
        ln -s $nodePath $f
      fi
    fi

    nodeVersion=$($f -v)
    echo "VS Code Node Version: $($f -v)"

    if [ "\''${nodeVersion:1:2}" != "14" ]; then
      echo "Unsupported VS Code Node version: $nodeVersion", quitting
      fail_with_exitcode ''${o.InstallExitCode.ServerTransferFailed}
    fi

    ${lib.optionalString useLocalExtensions ''
      # Use local extensions
      if [ -d $HOME/.vscode/extensions ]; then
        if ! [ -L $HOME/.vscode-server/extensions ]; then
          if [ -e $HOME/.vscode-server/extensions ]; then
            mv $HOME/.vscode-server/extensions $HOME/.vscode-server/extensions.bak
          fi

          mkdir -p $HOME/.vscode-server
          ln -s $HOME/.vscode/extensions $HOME/.vscode-server/extensions
        fi
      fi
    ''}

    echo "Checking $VSCH_LOGFILE''; # Don't add a trailing newline as we only matched part of a command
in
buildVscodeMarketplaceExtension {
  mktplcRef = {
    name = "remote-ssh";
    publisher = "ms-vscode-remote";
    version = "0.76.1";
    sha256 = "sha256-iLgGkf9hx75whXI+kmkmiGw3fnkEGp37Ae7GMdAz0+Y=";
  };

  postPatch = ''
    substituteInPlace "out/extension.js" \
      --replace 'echo "Checking $VSCH_LOGFILE' '${patch}'
  '';

  passthru.tests = { inherit (nixosTests) vscode-remote-ssh; };

  meta = with lib; {
    description = "Use any remote machine with a SSH server as your development environment.";
    license = licenses.unfree;
    maintainers = with maintainers; [ SuperSandro2000 tbenst Enzime ];
  };
}
