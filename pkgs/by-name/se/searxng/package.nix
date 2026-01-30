{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests,
  unstableGitUpdater,
}:
let
  python = python3.override {
    packageOverrides = final: prev: { };
  };
in
python.pkgs.toPythonModule (
  python.pkgs.buildPythonApplication rec {
    pname = "searxng";
    version = "0-unstable-2026-01-11";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "searxng";
      repo = "searxng";
      rev = "cf74e1d9e9ad662aef450ddd79aedee43554dc3c";
      hash = "sha256-hKnfZBPr8rJyZAYBtVXpyzXwBQqg2DPFwqzH08qCITs=";
    };

    nativeBuildInputs = with python.pkgs; [ pythonRelaxDepsHook ];

    pythonRelaxDeps = [
      "certifi"
      "flask"
      "flask-babel"
      "httpx-socks"
      "lxml"
      "markdown-it-py"
      "msgspec"
      "typer-slim"
      "whitenoise"
    ];

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

    build-system = with python.pkgs; [ setuptools ];

    dependencies =
      with python.pkgs;
      [
        babel
        certifi
        fasttext-predict
        flask
        flask-babel
        httpx
        httpx-socks
        isodate
        jinja2
        lxml
        markdown-it-py
        msgspec
        pygments
        python-dateutil
        pyyaml
        sniffio
        typer-slim
        typing-extensions
        valkey
        whitenoise
      ]
      ++ httpx.optional-dependencies.http2
      ++ httpx.optional-dependencies.socks
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

    meta = {
      homepage = "https://github.com/searxng/searxng";
      description = "Fork of Searx, a privacy-respecting, hackable metasearch engine";
      license = lib.licenses.agpl3Plus;
      mainProgram = "searxng-run";
      maintainers = with lib.maintainers; [
        SuperSandro2000
        _999eagle
      ];
    };
  }
)
