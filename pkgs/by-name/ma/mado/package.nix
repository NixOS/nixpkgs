{
  lib,
  stdenv,
  fetchzip,
}:
let
  inherit (stdenv.hostPlatform)
    system
    isAarch64
    isx86_64
    isDarwin
    isLinux
    ;

  arch =
    if isAarch64 then
      "arm64"
    else if isx86_64 then
      "x86_64"
    else
      throw "mado: unsupported architecture for ${system}";

  os =
    if isDarwin then
      "macOS"
    else if isLinux then
      "Linux-gnu"
    else
      throw "mado: unsupported OS for ${system}";

  hash =
    {
      x86_64-linux = "10x000gza9hac6qs4pfihfbsvk6fwbnjhy7vwh6zdmwwbvf9ikis";
      aarch64-linux = "0qr12gib7j7h2dpxfbz02p2hfchdwkyb9xa5qlq9yyr4d3j4lvr8";
      x86_64-darwin = "0q33bdz2c2mjl1dn1rdy859kkkamd7m6mabsswjz0rb5cy1cyyd4";
      aarch64-darwin = "1cv6vqk2aq2rybhbl0ybpnrq3r2cxf03p4cd1572s8w3i4mq6rql";
    }
    .${system} or (throw "mado: unsupported system ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mado";
  version = "0.3.0";

  src = fetchzip {
    stripRoot = false;
    url = "https://github.com/akiomik/mado/releases/download/v${finalAttrs.version}/mado-${os}-${arch}.tar.gz";
    sha256 = hash;
  };

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp -v mado "$out/bin/"
    chmod 0755 "$out/bin/mado"
    runHook postInstall
  '';

  meta = with lib; {
    description = "A fast Markdown linter written in Rust";
    homepage = "https://github.com/akiomik/mado";
    license = licenses.asl20;
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    mainProgram = "mado";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
