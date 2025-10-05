{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchpatch,
  makeDesktopItem,
  cmake,
  python3Packages,
  netcdf,
  glew,
  glm,
  libpng,
  libxml2,
  freetype,
  mmtf-cpp,
  msgpack,
  qt5,
}:
let
  pname = "pymol";
  description = "Python-enhanced molecular graphics tool";

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    desktopName = "PyMol Molecular Graphics System";
    genericName = "Molecular Modeler";
    comment = description;
    icon = pname;
    mimeTypes = [
      "chemical/x-pdb"
      "chemical/x-mdl-molfile"
      "chemical/x-mol2"
      "chemical/seq-aa-fasta"
      "chemical/seq-na-fasta"
      "chemical/x-xyz"
      "chemical/x-mdl-sdf"
    ];
    categories = [
      "Graphics"
      "Education"
      "Science"
      "Chemistry"
    ];
  };
in
python3Packages.buildPythonApplication rec {
  inherit pname;
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "schrodinger";
    repo = "pymol-open-source";
    rev = "v${version}";
    hash = "sha256-2C9kUpNfK9g7ehmk83iUVqqz4gn4wKO3lW5rSduFP6U=";
  };

  # A script is already created by the `[project.scripts]` directive
  # in `pyproject.toml`.
  patches = [
    ./script-already-exists.patch

    # Fix python3.13 and numpy 2 compatibility
    (fetchpatch {
      url = "https://github.com/schrodinger/pymol-open-source/commit/fef4a026425d195185e84d46ab88b2bbd6d96cf8.patch";
      hash = "sha256-F/5UcYwgHgcMQ+zeigedc1rr3WkN9rhxAxH+gQfWKIY=";
    })
    (fetchpatch {
      url = "https://github.com/schrodinger/pymol-open-source/commit/97cc1797695ee0850621762491e93dc611b04165.patch";
      hash = "sha256-H2PsRFn7brYTtLff/iMvJbZ+RZr7GYElMSINa4RDYdA=";
    })
    # Fixes failing test testLoadPWG
    (fetchpatch {
      url = "https://github.com/schrodinger/pymol-open-source/commit/17c6cbd96d52e9692fd298daec6c9bda273a8aad.patch";
      hash = "sha256-dcYRzUhiaGlR3CjQ0BktA5L+8lFyVdw0+hIz3Li7gDQ=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "self.install_libbase" '"${placeholder "out"}/${python3Packages.python.sitePackages}"'

    substituteInPlace pyproject.toml \
      --replace-fail '"cmake>=3.13.3",' ""
  '';

  env.PREFIX_PATH = lib.optionalString (!stdenv.hostPlatform.isDarwin) "${msgpack}";
  build-system = [ python3Packages.setuptools ];
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    glew
    glm
    libpng
    libxml2
    freetype
    netcdf
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    mmtf-cpp
    msgpack
  ];

  dependencies = with python3Packages; [
    numpy
    pyqt5
  ];

  env.NIX_CFLAGS_COMPILE = "-I ${libxml2.dev}/include/libxml2";

  postInstall =
    with python3Packages;
    ''
      wrapProgram $out/bin/pymol \
        --prefix PYTHONPATH : ${
          lib.makeSearchPathOutput "lib" python3Packages.python.sitePackages [
            pyqt5
            pyqt5.pyqt5-sip
          ]
        }

      mkdir -p "$out/share/icons/"
      ln -s $out/${python3Packages.python.sitePackages}/pymol/pymol_path/data/pymol/icons/icon2.svg "$out/share/icons/pymol.svg"
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      cp -r "${desktopItem}/share/applications/" "$out/share/"
    '';

  pythonImportsCheck = [ "pymol" ];

  nativeCheckInputs = with python3Packages; [
    python3Packages.msgpack
    pillow
    pytestCheckHook
    requests
  ];

  # some tests hang for some reason
  doCheck = !(stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);

  disabledTestPaths = [
    # require biopython which is broken as of 2024-04-20
    "tests/api/seqalign.py"
  ];

  disabledTests = [
    # the output image does not exactly match
    "test_commands"
    # touch the network
    "testFetch"
    # requires collada2gltf which is not included in nixpkgs
    "testglTF"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    # require mmtf-cpp which does not support darwin
    "test_bcif"
    "test_bcif_array"
    "testMMTF"
    "testSave_symmetry__mmtf"
  ];

  preCheck = ''
    cd testing
  '';

  __darwinAllowLocalNetworking = true;

  preFixup = ''
    wrapQtApp "$out/bin/pymol"
  '';

  meta = {
    inherit description;
    mainProgram = "pymol";
    homepage = "https://www.pymol.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      natsukium
      samlich
    ];
  };
}
