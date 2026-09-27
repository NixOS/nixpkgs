{
  lib,
  python3Packages,
  fetchFromGitHub,
  npf-renderer,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "priviblur";
  version = "0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "syeopite";
    repo = finalAttrs.pname;
    rev = "251a8e67c64d792b3c8c141860ccaa227ce62e4d";
    hash = "sha256-bN5jY2pEe+C5sZKz4reH0FWB21mZDMvte0GKOc7v/2c=";
  };

  # Doesn't follow any of the obvious python packaging methods
  format = "other";

  __structuredAttrs = true;

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    aiohttp
    aiosignal
    attrs
    babel
    dominate
    frozenlist
    html5tagger
    httptools
    idna
    intervaltree
    jinja2
    markupsafe
    multidict
    orjson
    pyyaml
    redis
    sanic
    sanic-ext
    pydantic
    sanic-routing
    sortedcontainers
    tracerite
    typing-extensions
    ujson
    uvloop
    websockets
    yarl
    npf-renderer
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/${finalAttrs.pname} $out/bin
    cp -r src locales assets $out/share/${finalAttrs.pname}/
    touch $out/share/${finalAttrs.pname}/src/__init__.py

    makeWrapper ${python3Packages.python.interpreter} $out/bin/${finalAttrs.pname} \
      --set PYTHONPATH "$PYTHONPATH:$out/share/${finalAttrs.pname}" \
      --add-flags "-m" \
      --add-flags "src.server"

    runHook postInstall
  '';

  meta = {
    description = "Privacy-focused alternative frontend to Tumblr";
    longDescription = ''
      Alternative web frontend for Tumblr that focuses on privacy and modern design,
      providing a lightweight and tracker-free experience.
    '';
    homepage = "https://github.com/syeopite/priviblur";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "priviblur";
  };
})
