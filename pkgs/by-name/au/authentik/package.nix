{ lib
, stdenvNoCC
, callPackages
, fetchFromGitHub
, fetchzip
, buildNpmPackage
, buildGoModule
, runCommand
, openapi-generator-cli
, nodejs
, python312
, codespell
, makeWrapper }:

let
  version = "2024.6.1";

  src = fetchFromGitHub {
    owner = "goauthentik";
    repo = "authentik";
    rev = "version/${version}";
    hash = "sha256-SMupiJGJbkBn33JP4WLF3IsBdt3SN3JvZg/EYlz443g=";
  };

  meta = with lib; {
    description = "Authentication glue you need";
    changelog = "https://github.com/goauthentik/authentik/releases/tag/version%2F${version}";
    homepage = "https://goauthentik.io/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jvanbruegge risson ];
  };

  website = buildNpmPackage {
    pname = "authentik-website";
    inherit version src meta;
    npmDepsHash = "sha256-JM+ae+zDsMdvovd2p4IJIH89KlMeDU7HOZjFbDCyehw=";

    NODE_ENV = "production";
    NODE_OPTIONS = "--openssl-legacy-provider";

    postPatch = ''
      cd website
    '';

    installPhase = ''
      mkdir $out
      cp -r build $out/help
    '';

    npmBuildScript = "build-bundled";
    npmFlags = [ "--ignore-scripts" ];
  };

  clientapi = stdenvNoCC.mkDerivation {
    pname = "authentik-client-api";
    inherit version src meta;

    postPatch = ''
      rm Makefile

      substituteInPlace ./scripts/api-ts-config.yaml \
        --replace-fail '/local' "$(pwd)/"
    '';

    nativeBuildInputs = [ openapi-generator-cli ];
    buildPhase = ''
      runHook preBuild
      openapi-generator-cli generate -i ./schema.yml \
      -g typescript-fetch -o $out \
      -c ./scripts/api-ts-config.yaml \
        --additional-properties=npmVersion=${nodejs.pkgs.npm.version} \
        --git-repo-id authentik --git-user-id goauthentik
      runHook postBuild
    '';
  };

  webui = buildNpmPackage {
    pname = "authentik-webui";
    inherit version meta;

    src = runCommand "authentik-webui-source" {} ''
      mkdir -p $out/web/node_modules/@goauthentik/
      cp -r ${src}/web $out/
      ln -s ${src}/package.json $out/
      ln -s ${src}/website $out/
      ln -s ${clientapi} $out/web/node_modules/@goauthentik/api
    '';
    npmDepsHash = "sha256-v9oD8qV5UDJeZn4GZDEPlVM/jGVSeTqdIUDJl6tYXZw=";

    postPatch = ''
      cd web
    '';

    installPhase = ''
      runHook preInstall
      mkdir $out
      cp -r dist $out/dist
      cp -r authentik $out/authentik
      runHook postInstall
    '';

    NODE_ENV = "production";
    NODE_OPTIONS = "--openssl-legacy-provider";

    npmInstallFlags = [ "--include=dev" ];
  };

  python = python312.override {
    self = python;
    packageOverrides = final: prev: {
      django-tenants = prev.buildPythonPackage rec {
        pname = "django-tenants";
        version = "unstable-2024-01-11";
        src = fetchFromGitHub {
          owner = "rissson";
          repo = pname;
          rev = "a7f37c53f62f355a00142473ff1e3451bb794eca";
          hash = "sha256-YBT0kcCfETXZe0j7/f1YipNIuRrcppRVh1ecFS3cvNo=";
        };
        format = "setuptools";
        doCheck = false; # Tests require postgres

        propagatedBuildInputs = with final; [
          django
          psycopg
          gunicorn
        ];
      };

      django-cte = prev.buildPythonPackage rec {
        pname = "django-cte";
        version = "1.3.3";
        src = fetchFromGitHub {
          owner = "dimagi";
          repo = pname;
          rev = "v${version}";
          hash = "sha256-OCENg94xHBeeE4A2838Cu3q2am2im2X4SkFSjc6DuhE=";
        };
        doCheck = false; # Tests require postgres
        format = "setuptools";
      };

      django-pgactivity = prev.buildPythonPackage rec {
        pname = "django-pgactivity";
        version = "1.4.1";
        src = fetchFromGitHub {
          owner = "Opus10";
          repo = pname;
          rev = version;
          hash = "sha256-VwH7fwLcoH2Z9D/OY9iieM0cRhyDKOpAzqQ+4YVE3vU=";
        };
        nativeBuildInputs = with prev; [
          poetry-core
        ];
        propagatedBuildInputs = with final; [
          django
        ];
        pyproject = true;
      };

      django-pglock = prev.buildPythonPackage rec {
        pname = "django-pglock";
        version = "1.5.1";
        src = fetchFromGitHub {
          owner = "Opus10";
          repo = pname;
          rev = version;
          hash = "sha256-ZoEHDkGmrcNiMe/rbwXsEPZo3LD93cZp6zjftMKjLeg=";
        };
        nativeBuildInputs = with prev; [
          poetry-core
        ];
        propagatedBuildInputs = with final; [
          django
          django-pgactivity
        ];
        pyproject = true;
      };

      tenant-schemas-celery = prev.buildPythonPackage rec {
        pname = "tenant-schemas-celery";
        version = "3.0.0";
        src = fetchFromGitHub {
          owner = "maciej-gol";
          repo = pname;
          rev = version;
          hash = "sha256-3ZUXSAOBMtj72sk/VwPV24ysQK+E4l1HdwKa78xrDtg=";
        };
        format = "setuptools";
        doCheck = false;

        propagatedBuildInputs = with final; [
          freezegun
          more-itertools
          psycopg2
        ];
      };

      scim2-filter-parser = prev.buildPythonPackage rec {
        pname = "scim2-filter-parser";
        version = "0.5.1";
        # For some reason the normal fetchPypi does not work
        src = fetchzip {
          url = "https://files.pythonhosted.org/packages/54/df/ad9718acce76e81a93c57327356eecd23701625f240fbe03d305250399e6/scim2_filter_parser-0.5.1.tar.gz";
          hash = "sha256-DZAdRj6qyySggsvJZC47vdvXbHrB1ra3qiYBEUiceJ4=";
        };

        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail 'poetry>=0.12' 'poetry-core>=1.0.0' \
            --replace-fail 'poetry.masonry.api' 'poetry.core.masonry.api'
        '';

        nativeBuildInputs = [ prev.poetry-core ];
        pyproject = true;

        propagatedBuildInputs = with final; [
          sly
        ];
      };

      authentik-django = prev.buildPythonPackage {
        pname = "authentik-django";
        inherit version src meta;
        pyproject = true;

        postPatch = ''
          rm lifecycle/system_migrations/tenant_files.py
          substituteInPlace authentik/root/settings.py \
            --replace-fail 'Path(__file__).absolute().parent.parent.parent' "\"$out\""
          substituteInPlace authentik/lib/default.yml \
            --replace-fail '/blueprints' "$out/blueprints" \
            --replace-fail './media' '/var/lib/authentik/media'
          substituteInPlace pyproject.toml \
            --replace-fail 'dumb-init = "*"' "" \
            --replace-fail 'djangorestframework = "3.14.0"' 'djangorestframework = "*"' \
            --replace-fail 'djangorestframework-guardian' 'djangorestframework-guardian2'
          substituteInPlace authentik/stages/email/utils.py \
            --replace-fail 'web/' '${webui}/'
        '';

        nativeBuildInputs = [ prev.poetry-core ];

        propagatedBuildInputs = with final; [
          argon2-cffi
          celery
          channels
          channels-redis
          colorama
          dacite
          daphne
          deepmerge
          defusedxml
          django
          django-cte
          django-filter
          django-guardian
          django-model-utils
          django-pglock
          django-prometheus
          django-redis
          django-storages
          django-tenants
          djangorestframework
          djangorestframework-guardian2
          docker
          drf-spectacular
          duo-client
          facebook-sdk
          fido2
          flower
          geoip2
          google-api-python-client
          gunicorn
          jsonpatch
          kubernetes
          ldap3
          lxml
          msgraph-sdk
          opencontainers
          packaging
          paramiko
          psycopg
          pycryptodome
          pydantic
          pydantic-scim
          pyjwt
          pyyaml
          requests-oauthlib
          scim2-filter-parser
          sentry-sdk
          service-identity
          setproctitle
          structlog
          swagger-spec-validator
          tenant-schemas-celery
          twilio
          twisted
          ua-parser
          urllib3
          uvicorn
          watchdog
          webauthn
          websockets
          wsproto
          xmlsec
          zxcvbn
        ] ++ [
          codespell
        ];

        postInstall = ''
          mkdir -p $out/web $out/website
          cp -r lifecycle manage.py $out/${prev.python.sitePackages}/
          cp -r blueprints $out/
          cp -r ${webui}/dist ${webui}/authentik $out/web/
          cp -r ${website} $out/website/help
          ln -s $out/${prev.python.sitePackages}/lifecycle $out/lifecycle
        '';
      };
    };
  };

  inherit (python.pkgs) authentik-django;

  proxy = buildGoModule {
    pname = "authentik-proxy";
    inherit version src meta;

    postPatch = ''
      substituteInPlace internal/gounicorn/gounicorn.go \
        --replace-fail './lifecycle' "${authentik-django}/lifecycle"
      substituteInPlace web/static.go \
        --replace-fail './web' "${authentik-django}/web"
      substituteInPlace internal/web/static.go \
        --replace-fail './web' "${authentik-django}/web"
    '';

    CGO_ENABLED = 0;

    vendorHash = "sha256-hxtyXyCfVemsjYQeo//gd68x4QO/4Vcww8i2ocsUVW8=";

    postInstall = ''
      mv $out/bin/server $out/bin/authentik
    '';

    subPackages = [ "cmd/server" ];
  };

in stdenvNoCC.mkDerivation {
  pname = "authentik";
  inherit src version;

  postPatch = ''
    rm Makefile
    patchShebangs lifecycle/ak

    # This causes issues in systemd services
    substituteInPlace lifecycle/ak \
      --replace-fail 'printf' '>&2 printf' \
      --replace-fail '> /dev/stderr' ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -r lifecycle/ak $out/bin/

    wrapProgram $out/bin/ak \
      --prefix PATH : ${lib.makeBinPath [ (python.withPackages (ps: [ps.authentik-django])) proxy ]} \
      --set TMPDIR /dev/shm \
      --set PYTHONDONTWRITEBYTECODE 1 \
      --set PYTHONUNBUFFERED 1
    runHook postInstall
  '';

  passthru.outposts = callPackages ./outposts.nix { };

  nativeBuildInputs = [ makeWrapper ];

  meta = meta // {
    mainProgram = "ak";
  };
}
