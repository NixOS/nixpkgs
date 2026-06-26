{
  lib,
  stdenv,
  fetchurl,
  installShellFiles,
}:

let
  sources = import ./sources.nix;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "box-cli";
  version = "0.1.112";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl sources.${stdenv.hostPlatform.system};

  dontUnpack = true;

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/box

    runHook postInstall
  '';

  meta = {
    description = "CLI for Ascii Box cloud sandboxes";
    homepage = "https://ascii.dev";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "box";
    platforms = lib.attrNames sources;
  };
})
