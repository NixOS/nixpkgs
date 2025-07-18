{
  fetchFromGitHub,
  fetchurl,
  jq,
  lib,
  podman,
  python3Packages,
  stdenv,
  writableTmpDirAsHomeHook,
}:

let
  version = "0.9.0";
  # note: the container SHA256 hashes are taken directly from upstream
  container =
    if stdenv.hostPlatform.isx86 then
      fetchurl {
        url = "https://github.com/freedomofpress/dangerzone/releases/download/v0.9.0/container-0.9.0-i686.tar";
        sha256 = "54ee61de9b282ac78a41697ad1ee6806394fbfb9c4df1da45f673da544328e55";
        meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
    else if stdenv.hostPlatform.isAarch64 then
      fetchurl {
        url = "https://github.com/freedomofpress/dangerzone/releases/download/v0.9.0/container-0.9.0-arm64.tar";
        sha256 = "bd435e739474d00bc37834083e948a836160503cf0ceaa556efc2f57e87571bb";
        meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
      }
    else
      throw "unsuppported platform ${stdenv.hostPlatform.system}";
  tessdata = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tessdata_fast";
    tag = "4.1.0";
    hash = "sha256-BAH7CDexCgZ5XFfWBmpGFSjj/nbJy4MRRb0ftC4DYdQ=";
  };
in
python3Packages.buildPythonApplication {
  pname = "dangerzone";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "freedomofpress";
    repo = "dangerzone";
    tag = "v${version}";
    hash = "sha256-VffPqgXMINgS06BhTs9MzTPepjkoZZMqzYhaEVDpZmI=";
  };

  patches = [
    ./download-tessdata.patch
    ./paths.patch
  ];

  nativeBuildInputs = [
    jq
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

  postPatch = ''
    substituteInPlace install/common/download-tessdata.py --replace-fail @tessdata@ ${tessdata}
  '';

  postBuild = ''
    ln -s ${container} share/container.tar
    tar xf ${container} --to-stdout index.json | jq -r '.manifests.[].annotations.["org.opencontainers.image.ref.name"]' > share/image-id.txt
    python install/common/download-tessdata.py
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
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
}
