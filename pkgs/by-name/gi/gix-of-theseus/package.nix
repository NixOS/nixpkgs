{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  python3Packages,
  makeWrapper,
}:
let
  version = "0-unstable-2025-11-04";
  src = fetchFromGitHub {
    owner = "amedeedaboville";
    repo = "gix-of-theseus";
    rev = "33ae4919c326cfcf6ab50fde5eaac425145b905c";
    hash = "sha256-79JfmLlmUftdxw7NI/VWuDBFqaxLaG6eHIPuYip4hfg=";
  };
  stackplot = python3Packages.buildPythonApplication {
    pname = "stackplot";
    inherit src version;

    pyproject = false;

    dependencies = with python3Packages; [
      matplotlib
      numpy
      python-dateutil
    ];
    dontWrapPythonPrograms = true;
    nativeBuildInputs = [ makeWrapper ];

    installPhase = ''
      runHook preInstall

      install -D src/stackplot.py -t $out/${python3Packages.python.sitePackages}

      makeWrapper ${python3Packages.python.interpreter} $out/bin/stackplot \
        --add-flags $out/${python3Packages.python.sitePackages}/stackplot.py \
        --prefix PYTHONPATH : "$out/${python3Packages.python.sitePackages}:$PYTHONPATH"

      runHook postInstall
    '';
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gix-of-theseus";
  __structuredAttrs = true;

  inherit src version;

  cargoHash = "sha256-GLfHQeJGAbFQVTek1hBZ8U2omyiuty2nnnHdbdlG0/4=";

  passthru.updateScript = nix-update-script { };

  patches = [
    ./0001-invoke-script-directly.patch
  ];

  postPatch = ''
    substituteInPlace src/plot.rs \
      --replace-fail \
        'let path = "stackplot.py";' \
        'let path = "'${stackplot}'/bin/stackplot";'
  '';

  meta = {
    description = "A Rust rewrite of git-of-theseus";
    homepage = "https://github.com/amedeedaboville/gix-of-theseus";
    changelog = "https://github.com/amedeedaboville/gix-of-theseus/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.dwoffinden ];
    mainProgram = "gix-of-theseus";
  };
})
