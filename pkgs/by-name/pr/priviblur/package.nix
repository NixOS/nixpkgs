{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  gettext,
  npf-renderer,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "priviblur";
  version = "0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "syeopite";
    repo = "priviblur";
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

  nativeBuildInputs = [
    gettext
    makeWrapper
  ];

  # Python 3.14 no longer resolves a class's __annotations__ via an instance.
  postPatch = ''
    substituteInPlace src/preferences.py \
      --replace-fail 'self.__annotations__.items()' 'type(self).__annotations__.items()'
  '';

  postInstall = ''
    mkdir -p $out/share/priviblur $out/bin
    cp -r src locales assets $out/share/priviblur/
    find $out/share/priviblur/locales -name '*.po' -exec sh -c 'for po do msgfmt --check -o "''${po%.po}.mo" "$po"; done' sh {} +
    touch $out/share/priviblur/src/__init__.py

    makeWrapper ${python3Packages.python.interpreter} $out/bin/priviblur \
      --set PYTHONPATH "$PYTHONPATH:$out/share/priviblur" \
      --chdir "$out/share/priviblur" \
      --add-flags "-m" \
      --add-flags "src.server"

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
