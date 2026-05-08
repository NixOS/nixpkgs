{
  lib,
  python3,
  python3Packages,
  fetchFromGitHub,
  makeBinaryWrapper,
}:

python3Packages.buildPythonApplication {
  pname = "linkfinder";
  version = "0-unstable-2024-04-13";
  pyproject = false;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "GerbenJavado";
    repo = "LinkFinder";
    rev = "1debac5dace4724fd6187c06f133578dae51c86f";
    hash = "sha256-B1mP2twGjuQC09GZodBl/8R2JhUKkU0q3ZQkPSXZbNI=";
  };

  nativeBuildInputs = [ makeBinaryWrapper ];

  propagatedBuildInputs = with python3Packages; [ jsbeautifier ];

  installPhase = ''
    runHook preInstall
    install -Dm644 linkfinder.py $out/share/linkfinder/linkfinder.py
    install -Dm644 template.html $out/share/linkfinder/template.html
    makeWrapper ${lib.getExe python3} $out/bin/linkfinder \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --add-flags "$out/share/linkfinder/linkfinder.py"
    runHook postInstall
  '';

  doCheck = false; # no test suite

  meta = {
    description = "Discover endpoints and parameters in JavaScript files";
    homepage = "https://github.com/GerbenJavado/LinkFinder";
    license = lib.licenses.mit;
    mainProgram = "linkfinder";
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
}
