{
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

  passthru = {
    run = throw "steam-run is only available for Linux; the Darwin steam package installs Valve's bootstrap app bundle.";
    run-free = throw "steam-run-free is only available for Linux; the Darwin steam package installs Valve's bootstrap app bundle.";
  };
}
