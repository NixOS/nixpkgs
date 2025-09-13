{
  lib,
  python3,
  fetchFromGitHub,
  sonic,
}:
let
  espeak-ng-src = fetchFromGitHub {
    owner = "espeak-ng";
    repo = "espeak-ng";
    rev = "212928b394a96e8fd2096616bfd54e17845c48f6";
    hash = "sha256-cDHna7U69/ZF8itwmKsKcl7JtaFfaJ3Hm4/nnhmZfS8=";
  };
in

python3.pkgs.buildPythonApplication rec {
  pname = "piper1-gpl";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "piper1-gpl";
    rev = "v${version}";
    hash = "sha256-WDMIXsbUzJ5XnA/KUVUPQKZzkqrXagzAOrhFtLR4fGk=";
  };

  build-system = with python3.pkgs; [
    cmake
    ninja
    scikit-build
    setuptools
    wheel
  ];

  patches = [ ./prevent-download.patch ];

  postConfigure = ''
    cd /build/source
    mkdir -p /build/source/_skbuild/linux-x86_64-3.13/cmake-build/espeak_ng/src
    cp -r ${espeak-ng-src} /build/source/_skbuild/linux-x86_64-3.13/cmake-build/espeak_ng/src/espeak_ng_external
  '';

  dependencies = [
    sonic
    python3.pkgs.onnxruntime
    python3.pkgs.flask
  ];

  pythonImportsCheck = [
    "piper"
  ];

  meta = {
    description = "Fast and local neural text-to-speech engine";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    changelog = "https://github.com/OHF-Voice/piper1-gpl/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ ];
    mainProgram = "piper1-gpl";
  };
}
