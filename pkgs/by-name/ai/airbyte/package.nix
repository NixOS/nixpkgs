{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, docker
, docker-compose
, testers
}:

stdenv.mkDerivation rec {
  pname = "airbyte";
  version = "v0.50.44";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = pname;
    rev = version;
    hash = "sha256-0urotetI/y3iuRo00SGuuST3dbdZAzoQPR/Pva2PJKU=";
  };

  base_github_url = "https://raw.githubusercontent.com/airbytehq/airbyte-platform/${
    version}/";

  docker-compose-yaml = fetchurl {
    url = base_github_url + "docker-compose.yaml";
    hash = "sha256-mYfKGNlKWG3c+Re52VouQa3uJLj5+mA7QY1+Cvnz21A=";
  };

  docker-compose-debug-yaml = fetchurl {
    url = base_github_url + "docker-compose.debug.yaml";
    hash = "sha256-032IYeu96XMCWcArphHL7l4Wol3GHAfMOOO8OanRIgg=";
  };

  dot-env = fetchurl {
    url = base_github_url + ".env";
    hash = "sha256-aNWpaDG1tMlycpGYPEa8FqSJzkxdzzgpUMfZ8W7P+ao=";
  };

  dot-env-dev = fetchurl {
    url = base_github_url + ".env.dev";
    hash = "sha256-wNB9rCyAxVmHgUX1PF/MgSSpAObhTm9cy3U1A8xFVOE=";
  };

  flags = fetchurl {
    url = base_github_url + "flags.yml";
    hash = "sha256-r73o3CTq/A/DeyD89cQ+u/RHqcZtD5HSsC2bomN0Tt0=";
  };

  temporal-yaml = fetchurl {
    url = base_github_url + "temporal/dynamicconfig/development.yaml";
    hash = "sha256-P9lMvBkFHa4PX484ZrB6ciX/kiupJhzw/5FeLrWv6Ew=";
  };

  passthru.tests.version = testers.testVersion {
    package = docker-compose;
    command = ''
      ${docker}/bin/docker compose version
    '';
    version = "2";
  };

  dontBuild = true;

  installPhase = ''
    # $out is an automatically generated filepath by nix,
    # but it's up to you to make it what you need. We'll create a directory at
    # that filepath, then copy our sources into it.
    mkdir $out
    cd $out
    cp -v $src/run-ab-platform.sh $out
    cp -v ${docker-compose-yaml} $out/docker-compose.yaml
    cp -v ${docker-compose-debug-yaml} $out/docker-compose.debug.yaml
    cp -v ${dot-env} $out/.env
    cp -v ${dot-env-dev} $out/.env.dev
    cp -v ${flags} $out/flags.yml
    mkdir -p temporal/dynamicconfig
    cp -v ${temporal-yaml} $out/temporal/dynamicconfig/development.yaml
  '';

  meta = with lib; {
    homepage = "https://airbyte.com/";
    description = "Simple & extensible open-source data integration.";
    longDescription = ''
      Data integration platform for ETL / ELT data pipelines
      APIs, databases & files to data warehouses, data lakes & data
      lakehouses.
    '';
    license = licenses.elastic20;
    maintainers = [ maintainers.dmvianna ];
    platforms = platforms.linux;
  };
}
