{
  bash,
  coreutils,
  gnused,
  goss,
  lib,
  resholve,
  which,
}:

resholve.mkDerivation rec {
  pname = "dgoss";
  version = goss.version;
  src = goss.src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    sed -i '2i GOSS_PATH=${goss}/bin/goss' extras/dgoss/dgoss
    install -D extras/dgoss/dgoss $out/bin/dgoss
  '';

  solutions = {
    default = {
      scripts = [ "bin/dgoss" ];
      interpreter = "${bash}/bin/bash";
      inputs = [
        coreutils
        gnused
        which
      ];
      keep = {
        "$CONTAINER_RUNTIME" = true;
      };
    };
  };

  meta = with lib; {
    homepage = "https://github.com/goss-org/goss/blob/v${version}/extras/dgoss/README.md";
    changelog = "https://github.com/goss-org/goss/releases/tag/v${version}";
    description = "Convenience wrapper around goss that aims to bring the simplicity of goss to docker containers";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hyzual anthonyroussel ];
    mainProgram = "dgoss";
  };
}
