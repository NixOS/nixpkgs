{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests
}:

python3.pkgs.toPythonModule (
  python3.pkgs.buildPythonApplication rec {
    pname = "searxng";
    version = "0-unstable-2024-11-25";

    src = fetchFromGitHub {
      owner = "searxng";
      repo = "searxng";
      rev = "bad070b4bc2c5afa73edea546c68d3e142a476fc";
      hash = "sha256-pJl0pD+lx1L7CMKEZaK15ahd96gwWKsR53EVF7RRNtY=";
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
      with python3.pkgs;
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
      ln -s ../${python3.sitePackages}/searx/static $out/share/

      # copy config schema for the limiter
      cp searx/limiter.toml $out/${python3.sitePackages}/searx/limiter.toml
    '';

    passthru = {
      tests = {
        searxng = nixosTests.searx;
      };
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
