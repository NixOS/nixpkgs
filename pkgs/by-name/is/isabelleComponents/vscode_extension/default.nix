{
  stdenvNoCC,
  fetchurl,
  vscode-utils,
}:

let
  vsix = stdenvNoCC.mkDerivation (finalAttrs: {
    name = "isabelle-${finalAttrs.version}.vsix";
    pname = "isabelle-vsix";
    version = "2.0.0";

    src = fetchurl {
      url = "https://isabelle.in.tum.de/components/vscode_extension-20251205.tar.gz";
      hash = "sha256-Rlekz2askYJWiWe5zEDVrnTp7yfUDxqmAIut1whFR0U=";
    };

    installPhase = ''
      runHook preInstall
      cp ./${finalAttrs.name} $out
      runHook postInstall
    '';
  });
in
vscode-utils.buildVscodeExtension (finalAttrs: {
  pname = "isabelle";
  inherit (vsix) version;

  vscodeExtPublisher = "isabelle";
  vscodeExtName = "isabelle";
  vscodeExtUniqueId = "${finalAttrs.vscodeExtPublisher}.${finalAttrs.vscodeExtName}";

  postPatch = ''
    rm -rf node-v*-linux-x64
  '';

  src = vsix;

  passthru = {
    inherit vsix;
    updateScript = null;
  };
})
