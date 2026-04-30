{
  coreutils,
  gnused,
  goss,
  lib,
  makeWrapper,
  stdenvNoCC,
  which,
}:

stdenvNoCC.mkDerivation {
  pname = "dgoss";
  inherit (goss) version src;

  nativeBuildInputs = [ makeWrapper ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -D extras/dgoss/dgoss $out/bin/dgoss

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/dgoss \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          gnused
          goss
          which
        ]
      }
  '';

  meta = {
    homepage = "https://github.com/goss-org/goss/blob/v${goss.version}/extras/dgoss/README.md";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${goss.version}";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      hyzual
      anthonyroussel
    ];
    mainProgram = "dgoss";
  };
}
