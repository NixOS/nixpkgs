{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.toPythonModule (python3.pkgs.buildPythonApplication rec {
  pname = "searxng";
  version = "0-unstable-2024-05-31";

  src = fetchFromGitHub {
    owner = "searxng";
    repo = "searxng";
    rev = "18fb701be225560b3fb1011cc533f785823f26a4";
    hash = "sha256-okE/Uxl7YqcM99kLJ4KAlMQi50x5m0bPfYp5bv62WEw=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt

    # can't be fetchpatched as it is essentially empty and it complains about that
    # TODO: drop when updating to a version that includes https://github.com/searxng/searxng/pull/3563
    touch searx/answerers/random/__init__.py
    touch searx/answerers/statistics/__init__.py
  '';

  preBuild =
    let
      versionString = lib.concatStringsSep "." (builtins.tail (lib.splitString "-" (lib.removePrefix "0-" version)));
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

  propagatedBuildInputs = with python3.pkgs; [
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
  ] ++ httpx.optional-dependencies.http2
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

  meta = with lib; {
    homepage = "https://github.com/searxng/searxng";
    description = "A fork of Searx, a privacy-respecting, hackable metasearch engine";
    license = licenses.agpl3Plus;
    mainProgram = "searxng-run";
    maintainers = with maintainers; [ SuperSandro2000 _999eagle ];
  };
})
