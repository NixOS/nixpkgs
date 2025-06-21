{
  stdenvNoCC,
  lib,
  fetchurl,
  unzip,
  runtimeShell,
  pname,
  version,
  meta,
  passthru,
}:

let
  appName = "Beekeeper Studio.app";

  dist =
    {
      aarch64-darwin = {
        fileName = "Beekeeper-Studio-${version}-arm64-mac.zip";
        sha256 = "sha256-wfDeMS6UuG87+VmONSx8DuBm+xFTVscA2EDAcUQu6og=";
      };
      x86_64-darwin = {
        fileName = "Beekeeper-Studio-${version}-mac.zip";
        sha256 = "sha256-4mNb6OjluCVHfGCW8dmfpPKayR8pesAqTRCjHJCPfpE=";
      };
    }
    .${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

in
stdenvNoCC.mkDerivation {
  inherit
    pname
    version
    meta
    passthru
    ;

  src = fetchurl {
    url = "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/v${version}/${dist.fileName}";
    inherit (dist) sha256;
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = appName;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications" "$out/bin"
    cp -R . "$out/Applications/${appName}"

    # Create a launcher script to run from the command line
    cat > "$out/bin/${pname}" << EOF
    #!${runtimeShell}
    open -na "$out/Applications/${appName}" --args "\$@"
    EOF
    chmod +x "$out/bin/${pname}"

    runHook postInstall
  '';
}
