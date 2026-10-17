{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  # These native bindings must match the Frida npm versions locked by igf.
  fridaVersion = "17.8.3";
  frida16Version = "16.7.19";

  assetSystems = {
    aarch64-darwin = "darwin-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-linux = "linux-arm64";
    x86_64-linux = "linux-x64";
  };

  hashes = {
    aarch64-darwin = {
      frida = "sha256-YUeJ1dRoeraX5ln3dqt4u/rGbs2DR8wiPs8rCG5zBj4=";
      frida16 = "sha256-KmDxDXGA6FxFhGY3SNvRriU/SJfXw6XkNOX6O0CtNpY=";
    };
    x86_64-darwin = {
      frida = "sha256-vnCIHUobOGfI83YgVQa6Ke9XUY07xHhCYUxCrONYvEw=";
      frida16 = "sha256-bnRd2BLK7XJFZvL1aJFNQ/2eI5QrMaKD4o++1/XrE6c=";
    };
    aarch64-linux = {
      frida = "sha256-nl7SbaiJIKc2qM99oNB+J/eHMGYML7LTOya5jAzc5So=";
      frida16 = "sha256-OImdJ/VGEkPi63TVf08T8N+qo/qxYCofdnatiocMDCc=";
    };
    x86_64-linux = {
      frida = "sha256-MTl8KGSMhJmi8TUXe4gF/YRysnPxOJL+hya4/WAS0ew=";
      frida16 = "sha256-5+dDsi/3lnyoV4kdwp2r3+/AbdhdUE4HByTDY1tJgok=";
    };
  };

  mkSource =
    version: assetSystem: hash:
    fetchurl {
      url = "https://github.com/frida/frida/releases/download/${version}/frida-v${version}-napi-v8-${assetSystem}.tar.gz";
      inherit hash;
    };

  sources = lib.mapAttrs (system: assetSystem: {
    frida = mkSource fridaVersion assetSystem hashes.${system}.frida;
    frida16 = mkSource frida16Version assetSystem hashes.${system}.frida16;
  }) assetSystems;

  prebuilds =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "frida-node-prebuilds";
  version = "${fridaVersion}-${frida16Version}";

  strictDeps = true;
  __structuredAttrs = true;

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/frida/build" "$out/frida16/build"

    tar -xOf ${prebuilds.frida} build/frida_binding.node > "$out/frida/build/frida_binding.node"
    tar -xOf ${prebuilds.frida16} build/frida_binding.node > "$out/frida16/build/frida_binding.node"

    runHook postInstall
  '';

  passthru = {
    inherit fridaVersion frida16Version sources;
    updateScript = ./update.py;
  };

  meta = {
    description = "Frida Node.js N-API prebuilt bindings for v17 and v16";
    homepage = "https://frida.re/";
    license = with lib.licenses; [
      lgpl2Only
      wxWindowsException31
    ];
    maintainers = with lib.maintainers; [ caverav ];
    platforms = lib.attrNames sources;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
