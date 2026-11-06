{
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  python312,
}:

let
  # The engine's Python bridge imports pandas while building its converters, so
  # Python algorithms need an interpreter that has it. Python 3.12 is the
  # version pythonnet supports.
  python = python312.withPackages (ps: [ ps.pandas ]);
in
buildDotnetModule (finalAttrs: {
  pname = "lean-engine";
  version = "0-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "QuantConnect";
    repo = "Lean";
    rev = "9ecfed98339c27849a2a708edc03455caf151e91";
    hash = "sha256-lpPunWC+bDefz8axXK4MTHy9jgLi5zDWdGH/SOQpwqo=";
  };

  projectFile = "Launcher/QuantConnect.Lean.Launcher.csproj";
  nugetDeps = ./deps.json;

  strictDeps = true;
  __structuredAttrs = true;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;

  patches = [ ./python-shutdown.patch ];

  # DownloaderDataProvider and Optimizer.Launcher both carry a
  # config.example.json, which `dotnet publish` refuses to lay down twice.
  dotnetFlags = [ "-p:ErrorOnDuplicatePublishOutputFiles=false" ];

  executables = [ "QuantConnect.Lean.Launcher" ];

  makeWrapperArgs = [
    # Python algorithms run through pythonnet, which loads libpython from this
    # path.
    "--set"
    "PYTHONNET_PYDLL"
    "${python312}/lib/libpython3.12.so"
    "--prefix"
    "PYTHONPATH"
    ":"
    "${python}/lib/python3.12/site-packages"
    "--prefix"
    "PATH"
    ":"
    "${python}/bin"
  ];

  postInstall = ''
    mkdir -p $out/share/lean-engine
    cp -r Data $out/share/lean-engine/Data

    # The published config keeps the data path of the repository layout, which
    # points nowhere once installed. The Python path is the same story: the
    # engine resolves `from AlgorithmImports import *` relative to its own
    # directory.
    substituteInPlace $out/lib/lean-engine/config.json \
      --replace-fail '"data-folder": "../../../Data/"' "\"data-folder\": \"$out/share/lean-engine/Data\"" \
      --replace-fail '"python-additional-paths": [],' "\"python-additional-paths\": [\"$out/lib/lean-engine\"],"
  '';

  # The Launcher has no tests of its own; the repository's test suite is a
  # separate project with its own data set.
  doCheck = false;

  meta = {
    description = "Algorithmic trading engine from QuantConnect";
    homepage = "https://github.com/QuantConnect/Lean";
    license = lib.licenses.asl20;
    mainProgram = "QuantConnect.Lean.Launcher";
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
})
