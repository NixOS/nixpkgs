{ lib
<<<<<<< HEAD
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, vscode-utils
, useLocalExtensions ? false
}:
# Note that useLocalExtensions requires that vscode-server is not running
# on host. If it is, you'll need to remove $HOME/.vscode-server,
# and redo the install by running "Connect to host" on client

let
  inherit (vscode-utils) buildVscodeMarketplaceExtension;

<<<<<<< HEAD
=======
  nodeVersion = "16";

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
    # Check if Node included with VS Code Server runs
    if ! nodeVersion=$($serverNode -v); then
      echo "VS Code Node Version: $nodeVersion"

      if ! nix-build "<nixpkgs>" -A patchelf --out-link "$serverDir/patchelf" || ! "$serverDir/patchelf/bin/patchelf" --version; then
        echo "Failed to get patchelf from nixpkgs"
      fi

      if [ -e $serverNode.orig ]; then
        cp $serverNode.orig $serverNode
      else
        cp $serverNode $serverNode.orig
      fi

      if ! nix-build "<nixpkgs>" -A bintools --out-link $serverDir/bintools; then
        echo "Failed to build bintools from nixpkgs"
      fi

      INTERPRETER=$(cat $serverDir/bintools/nix-support/dynamic-linker)

      echo "Interpreter from bintools: $INTERPRETER"

      if ! nix-build "<nixpkgs>" -A stdenv.cc.cc.lib --out-link $serverDir/cc; then
        echo "Failed to build stdenv.cc.cc.lib from nixpkgs"
      fi

      if ! $serverDir/patchelf/bin/patchelf --set-interpreter $INTERPRETER --set-rpath $serverDir/cc-lib/lib $serverNode; then
        echo "Failed to patch Node binary"
      fi

      rm "$serverDir/patchelf"
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fi

    nodeVersion=$($serverNode -v)
    echo "VS Code Node Version: $nodeVersion"

<<<<<<< HEAD
    if ! nodeVersion=$($serverNode -v); then
      echo "Unable to fix Node binary, quitting"
=======
    if [ "\''${nodeVersion:1:2}" != "${nodeVersion}" ]; then
      echo "Unsupported VS Code Node version: $nodeVersion", quitting
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  passthru.tests = { inherit (nixosTests) vscode-remote-ssh; };

  meta = {
    description = "Use any remote machine with a SSH server as your development environment.";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.tbenst ];
=======
  meta = {
    description = "Use any remote machine with a SSH server as your development environment.";
    license = lib.licenses.unfree;
    maintainers = [ lib.maintainers.SuperSandro2000 lib.maintainers.tbenst ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
