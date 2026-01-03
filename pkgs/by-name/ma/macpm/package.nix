{
  lib,

  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication {
  pname = "macpm";
  version = "0.24-unstable-2024-11-19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "visualcjy";
    repo = "macpm";
    rev = "7882d4c86c84bb23a8966ca57990de9b11397bd4";
    hash = "sha256-jqaPPvYbuL8q6grmBLyZLf8aDmjugYxMOWAh1Ix82jc=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    dashing
    humanize
    psutil
  ];

  # has no tests
  doCheck = false;

  # backwards compatibility for users still expecting 'asitop'
  postInstall = ''
    ln -rs $out/bin/macpm $out/bin/asitop
  '';

  pythonImportsCheck = [ "macpm" ];

  meta = {
    description = "Perf monitoring CLI tool for Apple Silicon; previously named 'asitop'";
    homepage = "https://github.com/visualcjy/macpm";
    mainProgram = "macpm";
    platforms = [ "aarch64-darwin" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      juliusrickert
      siriobalmelli
    ];
  };
}
