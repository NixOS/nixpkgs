{
  lib,
  callPackage,
  fetchFromGitHub,
  python3Packages,
  ffmpeg-headless,
  chromaprint,
  makeWrapper,
  nix-update-script,
  nixosTests,
  withLocalTranscription ? false,
}:

let
  version = "2.97.45";

  src = fetchFromGitHub {
    owner = "ttlequals0";
    repo = "MinusPod";
    tag = "v${version}";
    hash = "sha256-mUe66Ph/+Jg4J9TTbsAD+CqSujfuxlcF6xkAQgW0T78=";
  };

  frontend = callPackage ./frontend.nix {
    inherit src version;
  };

  pythonPackages = python3Packages;

  deps =
    with pythonPackages;
    [
      anthropic
      beautifulsoup4
      cryptography
      defusedxml
      feedparser
      flask
      flask-compress
      flask-limiter
      gunicorn
      huggingface-hub
      nh3
      numpy
      openai
      pillow
      pyacoustid
      pyjwt
      python-slugify
      rapidfuzz
      redis
      requests
      scikit-learn
      tldextract
    ]
    ++ lib.optionals withLocalTranscription [
      ctranslate2
      faster-whisper
    ];

  pythonPath = pythonPackages.makePythonPath deps;

  runtimeBinPath = lib.makeBinPath [
    ffmpeg-headless
    chromaprint
  ];
in
pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "minuspod";
  inherit version src;
  format = "other";

  __structuredAttrs = true;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    makeWrapper
  ];

  dependencies = deps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/minuspod

    cp -r src $out/lib/minuspod/src
    cp version.py $out/lib/minuspod/version.py
    cp openapi.yaml $out/lib/minuspod/openapi.yaml
    cp gunicorn.conf.py $out/lib/minuspod/gunicorn.conf.py
    cp -r assets $out/lib/minuspod/assets
    cp -r assets $out/lib/minuspod/assets_builtin

    mkdir -p $out/lib/minuspod/static
    cp -r ${frontend}/share/minuspod/ui $out/lib/minuspod/static/ui
    chmod -R a+rX $out/lib/minuspod/static/ui

    substituteInPlace $out/lib/minuspod/gunicorn.conf.py \
      --replace-fail 'src_dir = "/app/src"' 'src_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "src")'

    mkdir -p $out/bin
    makeWrapper ${pythonPackages.gunicorn}/bin/gunicorn $out/bin/minuspod \
      --chdir $out/lib/minuspod/src \
      --prefix PYTHONPATH : "$out/lib/minuspod/src:$out/lib/minuspod:${pythonPath}" \
      --prefix PATH : "${runtimeBinPath}" \
      --add-flags "-c $out/lib/minuspod/gunicorn.conf.py main_app:app"

    runHook postInstall
  '';

  doCheck = false;

  pythonImportsCheck = [ ];

  passthru = {
    inherit frontend;
    tests.basic = nixosTests.minuspod;
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Self-hosted server that removes ads from podcasts before you ever hit play";
    homepage = "https://github.com/ttlequals0/MinusPod";
    changelog = "https://github.com/ttlequals0/MinusPod/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tlvince ];
    platforms = lib.platforms.linux;
    mainProgram = "minuspod";
  };
})
