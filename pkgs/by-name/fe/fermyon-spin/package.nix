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

  # TODO: It'd be nice to write an update script that would update all of these
  # hashes together.
  packageHash =
    {
      x86_64-linux = "sha256-PmL71C8TAJJIq4uS5FgdQ3eRscilsZADWiZvzRV9Prs=";
      aarch64-linux = "sha256-WmxsGXpwKpY+A3AH6LnloTW3G1hsDcd6Sh7CcXcuv1o=";
      x86_64-darwin = "sha256-FcRYl5mKhcG2fe+eqZBy0BYbQ91Eg/mscVLuzPnkzwg=";
      aarch64-darwin = "sha256-vG8aYadCFJ2KqBWeVtD0xdL4nh+ShOsi5HudakDau5A=";
    }
    .${system} or (throw "Unsupported system: ${system}");

in
stdenv.mkDerivation rec {
  pname = "fermyon-spin";
  version = "3.4.1";

  # Use fetchurl rather than fetchzip as these tarballs are built by the project
  # and not by GitHub (and thus are stable) - this simplifies the update script
  # by allowing it to use the output of `nix store prefetch-file`.
  src = fetchurl {
    url = "https://github.com/fermyon/spin/releases/download/v${version}/spin-v${version}-${platform}.tar.gz";
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

  meta = with lib; {
    description = "Framework for building, deploying, and running fast, secure, and composable cloud microservices with WebAssembly";
    homepage = "https://github.com/fermyon/spin";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = with licenses; [ asl20 ];
    mainProgram = "spin";
    maintainers = with maintainers; [ mglolenstine ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
