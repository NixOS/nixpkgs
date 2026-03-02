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
    x86_64-linux = "sha256-B+LKXK7DFakiFNdanaqMeGxnfxoEI4caNtxnyZEcWgQ=";
    aarch64-linux = "sha256-FMYIO1miEulnz9logtXxau2mIuR1zS8oCG04DMx0HyQ=";
    x86_64-darwin = "sha256-I3Z1QqIu0iJBZWq6fUWouGfTYzNr/wj+0UFfq0wSy4Y=";
    aarch64-darwin = "sha256-AL1TUJO5jSNhjfZ/rLo9Do22oqVhpLqiRdGnvVaqvog=";
  };

  packageHash = packageHashes.${system} or (throw "Unsupported system: ${system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fermyon-spin";
  version = "3.5.1";

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
