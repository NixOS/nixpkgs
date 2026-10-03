{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  ansilove,
  fastfetch,
  tzdata,
}:

python3Packages.buildPythonApplication rec {
  pname = "durdraw";
  version = "0.30.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "durdraw";
    repo = "durdraw";
    tag = version;
    hash = "sha256-kiSqjULJqpz4mGTXfvM0R4N/YNvnG8OPz83QJMqKSXQ=";
  };

  patches = [
    ./fix-fastfetch-keys.patch
  ];

  build-system = with python3Packages; [ setuptools ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ansilove
      fastfetch
    ])
  ];

  postInstall = ''
    install -Dm644 durdraw.ini -t $out/share/durdraw
    cp -r themes examples $out/share/durdraw/
  '';

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  preCheck = ''
    # test_log_timestamp_timezone_local needs zoneinfo for America/Boise
    export TZDIR=${tzdata}/share/zoneinfo
  '';

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # TZ=America/Boise is not picked up in the darwin sandbox and falls back to UTC
    "test_log_timestamp_timezone_local"
  ];

  pythonImportsCheck = [ "durdraw" ];

  meta = {
    description = "ASCII, Unicode and ANSI art editor for Unix-like systems";
    homepage = "https://durdraw.org";
    changelog = "https://github.com/durdraw/durdraw/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tahuffman1s ];
    mainProgram = "durdraw";
    platforms = lib.platforms.unix;
  };
}
