{
  stdenvNoCC,
  lib,
  fetchurl,
  undmg,
  pname,
  version,
  meta,
}:

let
  sources = {
    "x86_64-darwin" = {
      url = "https://cdn-fastly.obsproject.com/downloads/obs-studio-${version}-macos-intel.dmg";
      hash = "sha256-fWEPWrHJ0UKQ2CfkSbLMntmbuLSaiQ0crPBhGs6+RPo=";
    };
    "aarch64-darwin" = {
      url = "https://cdn-fastly.obsproject.com/downloads/obs-studio-${version}-macos-apple.dmg";
      hash = "sha256-fAVmRGNqeUyxgoGvmNVLV5WtiwmF6VDZO4xRC2RbYpg=";
    };
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchurl (
    sources.${stdenvNoCC.system} or (throw "unsupported system ${stdenvNoCC.hostPlatform.system}")
  );

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -r *.app $out/Applications
    runHook postInstall
  '';

  meta = {
    inherit (meta) description longDescription homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ philocalyst ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = lib.attrNames sources;
  };
}
