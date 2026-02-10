{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  nodejs,
}:
let
  sources = builtins.fromJSON (builtins.readFile ./sources.json);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aws-cloudformation-languageserver";
  version = sources.version;
  src =
    let
      currentSystemSrc =
        sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
    in
    fetchzip {
      inherit (currentSystemSrc) url sha256;
      stripRoot = false;
    };
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}/

    mkdir -p $out/bin
    makeWrapper ${nodejs}/bin/node $out/bin/cfn-lsp-server \
      --add-flags "$out/lib/${finalAttrs.pname}/cfn-lsp-server-standalone.js"

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "CloudFormation Language Server";
    mainProgram = "cfn-lsp-server";
    homepage = "https://github.com/aws-cloudformation/cloudformation-languageserver";
    license = lib.licenses.asl20;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      mbarneyjr
    ];
  };
})
