{
  lib,
  stdenvNoCC,
  fetchurl,
  undmg,
  nix-update-script,
}:
let
  archs = {
    x86_64-darwin = {
      suffix = "x64";
      hash = "sha256-gIbdEJYxd7h4vccJCB5O+7xxO66stk2WK80IG9C/eA8=";
    };
    aarch64-darwin = {
      suffix = "arm64";
      hash = "sha256-D0tp1f1OxZ2ntuFTciMUyT3CY9srgcDQGR4lY2BHPOM=";
    };
  };
  system = archs.${stdenvNoCC.hostPlatform.system};
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "kap";
  version = "3.6.0";

  src = fetchurl {
    url = "https://github.com/wulkano/Kap/releases/download/v${finalAttrs.version}/Kap-${finalAttrs.version}-${system.suffix}.dmg";
    inherit (system) hash;
  };

  sourceRoot = ".";

  nativeBuildInputs = [ undmg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications
    cp -r *.app $out/Applications

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source screen recorder built with web technology";
    homepage = "https://getkap.co";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ f64u ];
    platforms = lib.platforms.darwin;
  };
})
