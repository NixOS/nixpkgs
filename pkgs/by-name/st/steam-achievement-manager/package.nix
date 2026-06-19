{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
  gcc,
  testers,
}:

let
  version = "2.0.3";

  sources = {
    "x86_64-linux" = {
      url = "https://github.com/mbwilding/steam-achievement-manager/releases/download/v${version}/sam-linux-x64.zip";
      hash = "sha256-9550vfHLrsPRKCRHOdnl3+AtjDVAMMUxWrcT/6f6vyk=";
    };
    "aarch64-darwin" = {
      url = "https://github.com/mbwilding/steam-achievement-manager/releases/download/v${version}/sam-mac-arm64.zip";
      hash = "sha256-mBGib35CqQB0EiCU2pK8rSGHEpoXTHQCWj5uQ4eSaUo=";
    };
    "x86_64-darwin" = {
      url = "https://github.com/mbwilding/steam-achievement-manager/releases/download/v${version}/sam-mac-x64.zip";
      hash = "sha256-styxsf4GJWRSkLGkud2hvz0UX81A/IA05v+3GJo9iDo=";
    };
  };

  source =
    sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in

stdenv.mkDerivation (finalAttrs: {
  pname = "steam-achievement-manager";
  inherit version;

  src = fetchzip {
    inherit (source) url hash;
    stripRoot = false;
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ gcc.cc.lib ];

  strictDeps = true;
  __structuredAttrs = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 sam $out/bin/sam
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 libsteam_api.so $out/lib/libsteam_api.so
    ''}
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm644 libsteam_api.dylib $out/lib/libsteam_api.dylib
    ''}
    runHook postInstall
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Steam Achievement Manager CLI";
    homepage = "https://github.com/mbwilding/steam-achievement-manager";
    license = lib.licenses.mit;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ mbwilding ];
    platforms = builtins.attrNames sources;
    mainProgram = "sam";
  };
})
