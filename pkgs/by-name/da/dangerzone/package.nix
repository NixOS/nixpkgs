{
  fetchFromGitHub,
  fetchMazetteDeps,
  fetchurl,
  jq,
  lib,
  mazette,
  podman,
  python3Packages,
  stdenv,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.9.1";
  src = fetchFromGitHub {
    owner = "freedomofpress";
    repo = "dangerzone";
    tag = "v${version}";
    hash = "sha256-BcBsFphIQ7JGOTeobGbbQopEptNWYxl3GOtRmDZDwAg=";
  };
  # note: the container SHA256 hashes are taken directly from upstream
  container =
    if stdenv.hostPlatform.isx86 then
      fetchurl {
        url = "https://github.com/freedomofpress/dangerzone/releases/download/v0.9.1/container-0.9.1-i686.tar";
        sha256 = "ff210840ef3ba595aac3af5848829437c0fbf83cb775ea6fa200184986e3cc72";
        meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
    else if stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://github.com/freedomofpress/dangerzone/releases/download/v0.9.1/container-0.9.1-arm64.tar";
        sha256 = "3e3396162c4b251165b936c0ccffbb59d7d387b8649b9e2bbde488921a6539b5";
        meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
    else
      throw "unsuppported platform ${stdenv.hostPlatform.system}";
  mazette-cache = fetchMazetteDeps {
    mazettefile = "${src}/pyproject.toml";
    lockfile = "${src}/mazette.lock";
    hash = "sha256-3IaQPl5llLZrMXiI3RdsqtYgAGb/Tv1HbISRzOv3C28=";
  };
in
python3Packages.buildPythonApplication {
  pname = "dangerzone";
  inherit version;
  pyproject = true;

  inherit src;

  patches = [
    ./paths.patch
  ];

  nativeBuildInputs = [
    jq
    mazette
  ];

  nativeCheckInputs = [
    podman
    python3Packages.numpy
    python3Packages.pytest-mock
    python3Packages.pytest-qt
    python3Packages.pytest-subprocess
    python3Packages.pytestCheckHook
    python3Packages.strip-ansi
    writableTmpDirAsHomeHook
  ];

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = [
    python3Packages.click
    python3Packages.colorama
    python3Packages.markdown
    python3Packages.packaging
    python3Packages.platformdirs
    python3Packages.pymupdf
    python3Packages.pyside6
    python3Packages.pyxdg
    python3Packages.requests
  ];

  # podman doesn't work in the build sandbox, so we have to skip any tests which use it
  disabledTests = [
    "TestContainer"
    "TestCliConversion"
    "test_hancom_office"
  ];
  disabledTestPaths = [
    "tests/gui" # flaky
    "tests/test_large_set.py" # excessively long duration
  ];

  postBuild = ''
    ln -s ${container} share/container.tar
    tar xf ${container} --to-stdout index.json | jq -r '.manifests.[].annotations.["org.opencontainers.image.ref.name"]' > share/image-id.txt
    XDG_CACHE_HOME=${mazette-cache} mazette install
  '';

  postInstall = ''
    mkdir -p $out/share/dangerzone
    cp -r share/* $out/share/dangerzone/
    mkdir -p $out/share/applications
    cp install/linux/press.freedom.dangerzone.desktop $out/share/applications/
    mkdir -p $out/share/icons/hicolor/64x64
    cp install/linux/press.freedom.dangerzone.png $out/share/icons/hicolor/64x64/
  '';

  meta = {
    description = "Convert potentially dangerous documents or images to safe PDFs";
    homepage = "https://dangerzone.rocks/";
    license = lib.licenses.agpl3Plus;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ lib.maintainers.keysmashes ];
    sourceProvenance = [ lib.sourceTypes.fromSource lib.sourceTypes.binaryNativeCode ];
  };
}
