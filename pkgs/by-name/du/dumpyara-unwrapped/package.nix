{
  lib,
  python3Packages,
  fetchFromGitHub,
  nix-update-script,
  _7zz,
  android-tools,
  erofs-utils,
}:
python3Packages.buildPythonApplication {
  pname = "dumpyara-unwrapped";
  version = "1.0.10-unstable-2025-09-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sebaubuntu-python";
    repo = "dumpyara";
    rev = "5afb75621df63bc3252274185438734b3d71213c";
    hash = "sha256-rPNjV1QrZFrroRbp8NtRIRjrs/ZDjRCjh69fHIIfvlA=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    brotli
    liblp
    lz4
    protobuf5
    py7zr
    sebaubuntu-libs
    zstandard
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        _7zz
        android-tools
        erofs-utils
      ]
    }"
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Android firmware dumper, rewritten in Python";
    homepage = "https://github.com/sebaubuntu-python/dumpyara";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "dumpyara";
  };
}
