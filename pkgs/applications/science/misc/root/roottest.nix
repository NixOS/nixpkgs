{ lib
, stdenv
, fetchFromGitHub
, cmake
, gtest
, lz4
, root
, zstd
}:

stdenv.mkDerivation rec {
  pname = "roottest";
  inherit (root) version;

  src = fetchFromGitHub {
    owner = "root-project";
    repo = "roottest";
    rev = "v" + builtins.replaceStrings [ "." ] [ "-" ] version;
    hash = "sha256-qiHoE1y8lCqRWSxuphViFT+RepZnMjK/8bk9jZJSPZk=";
  };

  dontInstall = true;

  postPatch = ''
    substituteInPlace cmake/modules/SearchInstalledSoftwareRoottest.cmake \
      --replace 'if(NOT TARGET gtest)' 'if(FALSE)'
    substituteInPlace python/CMakeLists.txt \
      --replace "find_python_module(pytest REQUIRED)" "" \
      --replace "if (PY_PYTEST_FOUND)" "if (TRUE)"
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ gtest lz4 root root.python root.python.pkgs.pytest zstd ];

  cmakeFlags = lib.optionals stdenv.isDarwin [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF" # https://github.com/NixOS/nixpkgs/pull/108496
    "-DCMAKE_DISABLE_FIND_PACKAGE_Python2=TRUE"
  ];

  postBuild = ''
    touch "$out"
  '';

  meta = with lib; {
    homepage = "https://root.cern.ch/";
    description = "The ROOT test suite";
    platforms = platforms.unix;
    maintainers = [ maintainers.veprbl ];
    license = licenses.lgpl21;
  };
}
