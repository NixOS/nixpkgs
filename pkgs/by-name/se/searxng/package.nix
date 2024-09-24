{
  lib,
  python3,
  fetchFromGitHub,
  nixosTests
}:

python3.pkgs.toPythonModule (
  python3.pkgs.buildPythonApplication rec {
    pname = "searxng";
    version = "0-unstable-2024-06-19";

    src = fetchFromGitHub {
      owner = "searxng";
      repo = "searxng";
      rev = "acf3f109b2a99a5e6f25f5f2975016a36673c6ef";
      hash = "sha256-NdFnB5JEaWo7gt+RwxKxkVtEL8uGLlc4z0ROHN+zoL4=";
    };

    postPatch = ''
      sed -i 's/==.*$//' requirements.txt
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
        certifi
        python-dateutil
        fasttext-predict
        flask
        flask-babel
        brotli
        jinja2
        lxml
        pygments
        pytomlpp
        pyyaml
        redis
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
