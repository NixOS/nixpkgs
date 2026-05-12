{
  lib,
  stdenv,
  python3Packages,
  fetchpatch,
  fetchPypi,
  replaceVars,
  clang,
  pkg-config,
  flex,
  glib,
  json-glib,
  llvmPackages,
  gst_all_1,
}:

python3Packages.buildPythonApplication rec {
  pname = "hotdoc";
  version = "0.17.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xNXf9kfwOqh6HS0GA10oGe3QmbkWNeOy7jkIKTV66fw=";
  };

  patches = [
    (replaceVars ./clang.patch {
      clang = lib.getExe clang;
      libclang = "${lib.getLib llvmPackages.libclang}/lib/libclang${stdenv.hostPlatform.extensions.sharedLibrary}";
    })

    # Fix build with gcc15
    (fetchpatch {
      name = "hotdoc-fix-c_comment_scanner-function-prototypes-gcc15.patch";
      url = "https://github.com/hotdoc/hotdoc/commit/adf8518431fafb78c9b47862a0a9a58824b6a421.patch";
      hash = "sha256-5y50Yk+AjV3aSk8H3k9od/Yvy09FyQQOcVOAcstQnw8=";
    })
  ];

  build-system = [ python3Packages.setuptools ];

  nativeBuildInputs = [
    pkg-config
    python3Packages.cmake
    flex
  ];

  buildInputs = [
    glib
    json-glib
    python3Packages.libxml2.dev
  ];

  dependencies = [
    python3Packages.appdirs
    python3Packages.backports-entry-points-selectable
    python3Packages.dbus-deviation
    python3Packages.faust-cchardet
    python3Packages.feedgen
    python3Packages.lxml
    python3Packages.networkx
    python3Packages.pkgconfig
    python3Packages.pyyaml
    python3Packages.schema
    python3Packages.setuptools # for pkg_resources
    python3Packages.toposort
    python3Packages.wheezy-template
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];

  # CMake is used to build CMARK, but the build system is still python
  dontUseCmakeConfigure = true;

  # Ensure C+GI+GST extensions are built and can be imported
  pythonImportsCheck = [
    "hotdoc.extensions.c.c_extension"
    "hotdoc.extensions.gi.gi_extension"
    "hotdoc.extensions.gst.gst_extension"
  ];

  pytestFlags = [
    # Run the tests by package instead of current dir
    "--pyargs"
    "hotdoc"
  ];

  disabledTestPaths = [
    # Executing hotdoc exits with code 1
    "tests/test_hotdoc.py::TestHotdoc::test_basic"
    "tests/test_hotdoc.py::TestHotdoc::test_explicit_conf_file"
    "tests/test_hotdoc.py::TestHotdoc::test_implicit_conf_file"
    "tests/test_hotdoc.py::TestHotdoc::test_private_folder"
  ];

  disabledTests = [
    # Test does not correctly handle path normalization for test comparison
    "test_cli_overrides"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Test does not correctly handle absolute /home paths on Darwin (even fake ones)
    "test_index"
  ];

  postPatch =
    # Hardcode libclang paths
    ''
      substituteInPlace hotdoc/extensions/c/c_extension.py \
        --replace "shutil.which('llvm-config')" 'True' \
        --replace "subprocess.check_output(['llvm-config', '--version']).strip().decode()" '"${lib.versions.major llvmPackages.libclang.version}"' \
        --replace "subprocess.check_output(['llvm-config', '--prefix']).strip().decode()" '"${lib.getLib llvmPackages.libclang}"' \
        --replace "subprocess.check_output(['llvm-config', '--libdir']).strip().decode()" '"${lib.getLib llvmPackages.libclang}/lib"'
    ''
    # <https://github.com/MathieuDuponchelle/cmark/pull/2>
    + ''
      patch -p1 -d cmark -i ${./fix-cmake-4.patch}
    '';

  # Make pytest run from a temp dir to have it pick up installed package for cmark
  preCheck = ''
    pushd $TMPDIR
  '';
  postCheck = ''
    popd
  '';

  passthru.tests = {
    inherit (gst_all_1) gstreamer gst-plugins-base;
  };

  meta = {
    description = "Tastiest API documentation system";
    homepage = "https://hotdoc.github.io/";
    license = [ lib.licenses.lgpl21Plus ];
    maintainers = [ ];
  };
}
