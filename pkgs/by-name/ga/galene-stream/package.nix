{
  lib,
  python3Packages,
  fetchFromGitHub,
  gitUpdater,
  nixosTests,
  galene,
  gobject-introspection,
  gst_all_1,
  libnice,
  wrapGAppsHook3,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "galene-stream";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "erdnaxe";
    repo = "galene-stream";
    tag = finalAttrs.version;
    hash = "sha256-3TdU3vBVuFle+jon2oJLa/rTLIiwYkvzscTDbMEXD1Q=";
  };

  patches = [
    # Python 3.14 no longer creates an implicit event loop and will raise a
    # RuntimeError if there is no current one [1^], so we need to do this
    # ourselves.
    #
    # [1^]: https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.get_event_loop
    ./create-and-set-current-event-loop.patch
  ];

  postPatch = ''
    # When insecure is enabled on both galene and galene-stream, passing the
    # ssl_context with certificate checking disabled when trying to open a
    # websocket connection to ws:// errors out, because no ssl_context is
    # expected to be passed for an SSL-less websocket like that.
    #
    # When --insecure in galene-stream, don't pass ssl_context here.
    #
    # TODO: How does this interact with a galene with insecure disabled?
    # Expecting endpoint there to be wss://. Might need more sophisticated
    # patch.
    substituteInPlace galene_stream/galene.py \
      --replace-fail \
        'await websockets.connect(status["endpoint"], ssl=ssl_context)' \
        'await websockets.connect(status["endpoint"], ssl=None if self.insecure else ssl_context)'
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  buildInputs = [
    libnice # libgstnice.so
  ]
  ++ (with gst_all_1; [
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad
    gst-plugins-ugly # libgstx264.so
  ]);

  dependencies = with python3Packages; [
    pygobject3
    websockets
  ];

  dontWrapGApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  passthru = {
    tests.vm = nixosTests.galene.stream;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Gateway to send UDP, RTMP, SRT or RIST streams to Galène videoconference server";
    homepage = "https://github.com/erdnaxe/galene-stream";
    changelog = "https://github.com/erdnaxe/galene-stream/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    inherit (galene.meta) maintainers;
  };
})
