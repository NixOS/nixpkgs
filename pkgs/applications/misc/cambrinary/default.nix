{ lib
, buildPythonApplication
, fetchFromGitHub
, fetchpatch
, flit-core
, aiohttp
, beautifulsoup4
}:

buildPythonApplication rec {
  pname = "cambrinary";
  version = "unstable-2023-07-16";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "xueyuanl";
    repo = "cambrinary";
    rev = "f0792ef70654a48a7677b6e1a7dee454b2c0971c";
    hash = "sha256-wDcvpKAY/6lBjO5h3qKH3+Y2G2gm7spcKCXFMt/bAtE=";
  };

  patches = [
    # https://github.com/xueyuanl/cambrinary/pull/21
    (fetchpatch {
      name = "replace-flit-with-flit-core.patch";
      url = "https://github.com/xueyuanl/cambrinary/commit/99a9677d0e6d817c2aae80dd6d71a9a0ad7748c7.patch";
      hash = "sha256-w7j9y12CL0FBFkNCWGxl7A8ZiTgPMNUn+SnRTIjefog=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
  ];

  pythonImportsCheck = [ "cambrinary" ];

  meta = with lib; {
    description = "Cambridge dictionary in a terminal";
    homepage = "https://github.com/xueyuanl/cambrinary";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ azahi ];
  };
}
