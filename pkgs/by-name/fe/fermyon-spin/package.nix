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
    x86_64-linux = "sha256-xlBByHwsyV/ygbQZf1k4cWCI7jqcuufseVpNc4lERaM=";
    aarch64-linux = "sha256-7/UEYdPsedLEqa/kCR23lz4tmhkhYVwFkXutRAtF8eo=";
    x86_64-darwin = "sha256-IeA5VWobAZtBsmE15U57PmwWRGhW0l+abytRA9AEERk=";
    aarch64-darwin = "sha256-HwO3G6MnQP8yG4rzQKt1GkxCfuSSOtC1zOrSNWQzxx4=";
  };

  packageHash = packageHashes.${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fermyon-spin";
  version = "3.6.2";

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
