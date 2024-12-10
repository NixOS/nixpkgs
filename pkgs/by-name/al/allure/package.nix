{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  jre,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "allure";
  version = "2.31.0";

  src = fetchurl {
    url = "https://github.com/allure-framework/allure2/releases/download/${finalAttrs.version}/allure-${finalAttrs.version}.tgz";
    hash = "sha256-rhuIf+lwxw55SscOmtCsbrcIdjpTTM9joQbMbx8G0Uw=";
  };

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}
    cd "$out/share"
    tar xvzf $src
    makeWrapper $out/share/${finalAttrs.meta.mainProgram}-${finalAttrs.version}/bin/allure $out/bin/${finalAttrs.meta.mainProgram} \
      --prefix PATH : "${jre}/bin"

    runHook postInstall
  '';

  meta = {
    homepage = "https://docs.qameta.io/allure/";
    description = "Allure Report is a flexible, lightweight multi-language test reporting tool";
    longDescription = ''
      Allure Report is a flexible, lightweight multi-language test reporting
      tool providing clear graphical reports and allowing everyone involved
      in the development process to extract the maximum of information from
      the everyday testing process.
    '';
    license = lib.licenses.asl20;
    mainProgram = "allure";
    maintainers = with lib.maintainers; [ happysalada ];
  };
})
