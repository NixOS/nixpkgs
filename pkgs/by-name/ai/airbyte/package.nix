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
  version = "v0.50.50";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = pname;
    rev = version;
    hash = "sha256-FV6mz9354gd0YYG385DAN1v/SG2e+NNqEStnAub2Zac=";
  };

  base_github_url = "https://raw.githubusercontent.com/airbytehq/airbyte-platform/${
    version}/";

  docker-compose-yaml = fetchurl {
    url = base_github_url + "docker-compose.yaml";
    hash = "sha256-c+/daTFmc6B/aPTmhgvqAQjhClZF79HOykJCs+MkBPM=";
  };

  docker-compose-debug-yaml = fetchurl {
    url = base_github_url + "docker-compose.debug.yaml";
    hash = "sha256-032IYeu96XMCWcArphHL7l4Wol3GHAfMOOO8OanRIgg=";
  };

  dot-env = fetchurl {
    url = base_github_url + ".env";
    hash = "sha256-ihDmLc9oXItBIE0Cj5gLznejsNcqyYWy8kbUm5fm7Lw=";
  };

  dot-env-dev = fetchurl {
    url = base_github_url + ".env.dev";
    hash = "sha256-wNB9rCyAxVmHgUX1PF/MgSSpAObhTm9cy3U1A8xFVOE=";
  };

  flags = fetchurl {
    url = base_github_url + "flags.yml";
    hash = "sha256-5OkCrhOlU9oxztGII314yuI3/QY+XxWDiyoiqNFFGp4=";
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
