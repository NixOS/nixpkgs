{
  callPackage,
  steam-unwrapped,
  stdenvNoCC,
  ...
}:

let
  linuxSteam = callPackage ./linux.nix { inherit steam-unwrapped; };
in
stdenvNoCC.mkDerivation {
  pname = "steam";
  inherit (steam-unwrapped) version meta;

  dontConfigure = true;
  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    ln -s ${steam-unwrapped}/Applications "$out/Applications"
    ln -s ${steam-unwrapped}/bin "$out/bin"

    runHook postInstall
  '';

  passthru = {
    inherit (linuxSteam) buildRuntimeEnv;
  };
}
