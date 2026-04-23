{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  gcc-unwrapped,
  zlib,
}:

let
  system = stdenv.hostPlatform.system;

  platform =
    {
      x86_64-linux = "linux-amd64";
      aarch64-linux = "linux-aarch64";
      x86_64-darwin = "macos-amd64";
      aarch64-darwin = "macos-aarch64";
    }
    .${system} or (throw "Unsupported system: ${system}");

  packageHashes = {
    x86_64-linux = "sha256-L0Jwo4jY/HhRJGVtKWJ5qdZY+7y59bZClry86f87Snw=";
    aarch64-linux = "sha256-wCUt6cDAohU8kG3uII/u9gP3K6uVssGnAS1QP0B/kgE=";
    x86_64-darwin = "sha256-G7G9hzhtL1ILQTS96qEoZU//yVozvyFjnGT8Vot4pbk=";
    aarch64-darwin = "sha256-xwXeiyWMrN7iXk2e4m7PQmcgtLcUgHt67xShBGmn3Mk=";
  };

  packageHash = packageHashes.${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fermyon-spin";
  version = "3.6.3";

  # Use fetchurl rather than fetchzip as these tarballs are built by the project
  # and not by GitHub (and thus are stable) - this simplifies the update script
  # by allowing it to use the output of `nix store prefetch-file`.
  src = fetchurl {
    url = "https://github.com/spinframework/spin/releases/download/v${finalAttrs.version}/spin-v${finalAttrs.version}-${platform}.tar.gz";
    hash = packageHash;
  };

  sourceRoot = ".";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
  ];

  buildInputs = [
    gcc-unwrapped.lib
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./spin $out/bin

    runHook postInstall
  '';

  passthru = {
    inherit packageHashes; # needed by updateScript
    updateScript = ./update.py;
  };

  meta = {
    description = "Framework for building, deploying, and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://github.com/spinframework/spin";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = with lib.licenses; [ asl20 ];
    mainProgram = "spin";
    maintainers = [ ];
    platforms = builtins.attrNames packageHashes;
  };
})
