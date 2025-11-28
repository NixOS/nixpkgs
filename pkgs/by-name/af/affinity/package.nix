{ lib, stdenv, fetchurl, undmg}:

let
  # Binary DMGs for each Darwin arch
  sources = {
    x86_64-darwin = fetchurl {
      url  = "https://downloads.affinity.studio/Affinity.dmg";
      hash = "sha256-Ew3fukQWwKOrl/l7dPy6ZWj9sN592V1l+qep0zvQRIk=";
    };

    aarch64-darwin = fetchurl {
      url  = "https://downloads.affinity.studio/Affinity.dmg";
      hash = "sha256-Ew3fukQWwKOrl/l7dPy6ZWj9sN592V1l+qep0zvQRIk=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname   = "affinity";
  version = "3.0.1";

  # Pick the right DMG for the current platform
  # Using this system allows a future multi-platform build if needed
  src = sources.${stdenv.hostPlatform.system};

  # Needed to unpack .dmg
  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  ## Needs to be adjusted if Affinity releases separate builds per architecture
  ## For now, linux builds are not available, so we use the same DMG for both archs


  # Let the default unpackPhase handle the DMG using undmg.
  # We only override installPhase.
  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    # Adjust this if the .app name inside the DMG is different:
    # e.g. "Affinity 3.app" or "Affinity by Canva.app"
    cp -R "Affinity.app" "$out/Applications/Affinity.app"

    # CLI wrapper so `nix run` / `affinity` works
    mkdir -p "$out/bin"
    cat > "$out/bin/affinity" <<EOF
    #!/usr/bin/env bash
    exec /usr/bin/open "$out/Applications/Affinity.app" "\$@"
    EOF
    chmod +x "$out/bin/affinity"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Affinity all-in-one creative app";
    homepage    = "https://www.affinity.studio";
    license     = licenses.unfree;
    platforms   = platforms.darwin; # Affinity is only available for macOS at this time
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ demis ];
    mainProgram = "affinity";
  };
})
