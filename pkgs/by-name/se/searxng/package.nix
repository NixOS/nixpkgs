{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  unstableGitUpdater,
}:
let
  python = python3.override {
    packageOverrides = final: prev: {
      httpx = prev.httpx.overridePythonAttrs (old: rec {
        version = "0.27.2";
        src = old.src.override {
          tag = version;
          hash = "sha256-N0ztVA/KMui9kKIovmOfNTwwrdvSimmNkSvvC+3gpck=";
        };
      });

      httpx-socks = prev.httpx-socks.overridePythonAttrs (old: rec {
        version = "0.9.2";
        src = old.src.override {
          tag = "v${version}";
          hash = "sha256-PUiciSuDCO4r49st6ye5xPLCyvYMKfZY+yHAkp5j3ZI=";
        };
      });

      starlette = prev.starlette.overridePythonAttrs (old: {
        disabledTests = old.disabledTests or [ ] ++ [
          # fails in assertion with spacing issue
          "test_request_body"
          "test_request_stream"
          "test_wsgi_post"
        ];
      });
    };
  };
in
python.pkgs.toPythonModule (
  python.pkgs.buildPythonApplication rec {
    pname = "searxng";
    version = "0-unstable-2025-06-28";
    format = "setuptools";

    src = fetchFromGitHub {
      owner = "searxng";
      repo = "searxng";
      rev = "df76647c52b56101f152c5dec7c1d08f1732ceb7";
      hash = "sha256-8Rh42DFLyQz+4cWA8x5wpFO41DusMuTo8NAloprw5w0=";
    };

    postPatch = ''
      sed -i 's/==/>=/' requirements.txt
    '';

    preBuild =
      let
        versionString = lib.concatStringsSep "." (
          builtins.tail (lib.splitString "-" (lib.removePrefix "0-" version))
        );
        commitAbbrev = builtins.substring 0 8 src.rev;
      in
      ''
        export SEARX_DEBUG="true";

        cat > searx/version_frozen.py <<EOF
        VERSION_STRING="${versionString}+${commitAbbrev}"
        VERSION_TAG="${versionString}+${commitAbbrev}"
        DOCKER_TAG="${versionString}-${commitAbbrev}"
        GIT_URL="https://github.com/searxng/searxng"
        GIT_BRANCH="master"
        EOF
      '';

    dependencies =
      with python.pkgs;
      [
        babel
        brotli
        certifi
        fasttext-predict
        flask
        flask-babel
        isodate
        jinja2
        lxml
        msgspec
        pygments
        python-dateutil
        pyyaml
        redis
        typer
        uvloop
        setproctitle
        httpx
        httpx-socks
        markdown-it-py
      ]
      ++ httpx.optional-dependencies.http2
      ++ httpx-socks.optional-dependencies.asyncio;

    # tests try to connect to network
    doCheck = false;

    postInstall = ''
      # Create a symlink for easier access to static data
      mkdir -p $out/share
      ln -s ../${python.sitePackages}/searx/static $out/share/

      # copy config schema for the limiter
      cp searx/limiter.toml $out/${python.sitePackages}/searx/limiter.toml
    '';

    passthru = {
      tests = {
        searxng = nixosTests.searx;
      };
      updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };
    };

    meta = with lib; {
      homepage = "https://github.com/searxng/searxng";
      description = "Fork of Searx, a privacy-respecting, hackable metasearch engine";
      license = licenses.agpl3Plus;
      mainProgram = "searxng-run";
      maintainers = with maintainers; [
        SuperSandro2000
        _999eagle
      ];
    };
  }
)
