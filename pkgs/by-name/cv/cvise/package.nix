{
  lib,
  python3Packages,
  fetchFromGitHub,
  clang-tools,
  colordiff,
  flex,
  llvmPackages_20,
  unifdef,
  testers,
  cvise,
}:

let
  # cvise needs a port to latest llvm-21:
  #   https://github.com/marxin/cvise/issues/340
  inherit (llvmPackages_20) llvm libclang;

in
python3Packages.buildPythonApplication rec {
  pname = "cvise";
  version = "2.12.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "marxin";
    repo = "cvise";
    tag = "v${version}";
    hash = "sha256-UaWOHjgTiSVvpKKw6VFAeRAYkYp4y0Dnamzr7yhH0vQ=";
  };

  patches = [
    # Refer to unifdef by absolute path.
    ./unifdef.patch
  ];

  postPatch = ''
    # Avoid blanket -Werror to evade build failures on less
    # tested compilers.
    substituteInPlace CMakeLists.txt \
      --replace-fail " -Werror " " "

    substituteInPlace cvise/utils/testing.py \
      --replace-fail "'colordiff --version'" "'${colordiff}/bin/colordiff --version'" \
      --replace-fail "'colordiff'" "'${colordiff}/bin/colordiff'"
  '';

  nativeBuildInputs = [
    python3Packages.cmake
    flex
    llvm.dev
  ];

  buildInputs = [
    libclang
    llvm
    llvm.dev
    unifdef
  ];

  propagatedBuildInputs = [
    python3Packages.chardet
    python3Packages.pebble
    python3Packages.psutil
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    unifdef
  ];

  cmakeFlags = [
    # By default `cvise` looks it up in `llvm` bin directory. But
    # `nixpkgs` moves it into a separate derivation.
    "-DCLANG_FORMAT_PATH=${clang-tools}/bin/clang-format"
  ];

  disabledTests = [
    # Needs gcc, fails when run noninteractively (without tty).
    "test_simple_reduction"
  ];

  passthru = {
    tests = {
      # basic syntax check
      help-output = testers.testVersion {
        package = cvise;
        command = "cvise --version";
      };
    };
  };

  meta = {
    homepage = "https://github.com/marxin/cvise";
    description = "Super-parallel Python port of C-Reduce";
    license = lib.licenses.ncsa;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
