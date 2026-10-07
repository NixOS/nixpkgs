{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  installShellFiles,
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

  build-system = with python3Packages; [ setuptools ];

  nativeBuildInputs = [ installShellFiles ];

  dependencies = with python3Packages; [ pillow ];

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
    installManPage durdraw.1 durfetch.1 durview.1
    install -Dm644 durdraw.desktop -t $out/share/applications
    install -Dm644 durdraw.png -t $out/share/pixmaps
    install -Dm644 durdraw.ini -t $out/share/doc/durdraw
  '';

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
    description = "ASCII, Unicode and ANSI art editor";
    longDescription = ''
      Terminal-based ASCII, ANSI and Unicode art editor for Unix-like systems.
      Supports frame-based animation, custom themes, 256-color and 16-color
      modes, terminal mouse input, IRC color export, Unicode and Code Page 437
      block characters, and PNG/GIF export via ansilove.
    '';
    homepage = "https://durdraw.org";
    changelog = "https://github.com/durdraw/durdraw/releases/tag/${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tahuffman1s ];
    mainProgram = "durdraw";
    platforms = lib.platforms.unix;
  };
}
