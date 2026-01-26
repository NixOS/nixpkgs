{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gz-cmake,
  nix-update-script,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gz-tools";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "gazebosim";
    repo = "gz-tools";
    tag = "gz-tools${lib.versions.major finalAttrs.version}_${finalAttrs.version}";
    hash = "sha256-xMFJylj7OnDc7zVWiI4a/mvNpu9scz83F3bGopCt8l8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    coreutils # For env
  ];

  buildInputs = [ gz-cmake ];

  # Disable automatic shebang patching since we'll do it manually
  dontPatchShebangs = true;

  postFixup = ''
    if [ -f "$out/bin/gz" ]; then
      # Check if it's a text file (script)
      if head -n1 "$out/bin/gz" | grep -q '^#!'; then
        # Replace the shebang with the correct path to env
        substituteInPlace "$out/bin/gz" \
          --replace '#!/usr/bin/env' '#!${coreutils}/bin/env' \
          --replace '#!/bin/env' '#!${coreutils}/bin/env'

        # Ensure executable permissions
        chmod +x "$out/bin/gz"
      fi
    fi
  '';

  doInstallCheck = true;

  installCheckPhase = ''
    # Verify the binary exists and can be executed
    if [ -x "$out/bin/gz" ]; then
      "$out/bin/gz" --help >/dev/null || true
    fi
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "gz-tools";
    };
  };

  meta = {
    description = "Gazebo Sim tools collection";
    homepage = "https://gazebosim.org/";
    downloadPage = "https://github.com/gazebosim/gz-tools";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ guelakais ];
    platforms = lib.platforms.all;
    mainProgram = "gz";
  };
})
