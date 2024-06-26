{ lib
, stdenvNoCC
, fetchFromGitHub
, resholve

, bash
, coreutils
, curl
, gnugrep
, gnused
, jq
, lldap
, util-linux
}:

resholve.mkDerivation rec {
  pname = "lldap-cli";
  version = "0-unstable-2024-05-15";

  src = fetchFromGitHub {
    owner = "ibizaman";
    repo = pname;
    rev = "65c4102ab0b314593d69c02a803a11ba1853978f";
    hash = "sha256-Ip1FkDrIsphi0GjP805Y8Gii16x7v/fsHtDUOzxie0w=";
  };

  solutions = {
    default = {
      scripts = [ "bin/lldap-cli" ];
      interpreter = lib.getExe bash;
      inputs = [
        coreutils
        curl
        gnugrep
        gnused
        jq
        lldap
        util-linux
      ];
      keep = {
        "$value" = true;
      };
    };
  };

  installPhase = ''
    runHook preInstall

    install -Dm555 $src/lldap-cli $out/bin/lldap-cli

    runHook postInstall
  '';

  meta = {
    description = "Command line interface for LLDAP";
    homepage = "https://github.com/ibizaman/lldap-cli";
    license = lib.licenses.gpl3;
    mainProgram = "lldap-cli";
    maintainers = with lib.maintainers; [ ibizaman ];
    platforms = lib.platforms.all;
  };
}
