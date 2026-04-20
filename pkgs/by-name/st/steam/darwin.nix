{
  callPackage,
  steam-unwrapped,
  stdenvNoCC,
  ...
}:

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
}
