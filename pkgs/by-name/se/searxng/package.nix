{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.toPythonModule (python3.pkgs.buildPythonApplication rec {
  pname = "searxng";
  version = "0-unstable-2024-03-08";

  src = fetchFromGitHub {
    owner = "searxng";
    repo = "searxng";
    rev = "9c08a0cdddae7ceafbe5e00ce94cf7f1d36c97e0";
    hash = "sha256-0qlOpJqpOmseIeIafd0NLd2lF5whu18QxmwOua8dKzg=";
  };

  postPatch = ''
    sed -i 's/==.*$//' requirements.txt
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
