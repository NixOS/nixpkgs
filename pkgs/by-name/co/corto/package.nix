{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corto";
  version = "unstable-2023-06-27";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = finalAttrs.pname;
    rev = "f5df939c2dd4531b198e139505e2b9ed61d2ac25";
    hash = "sha256-M1GhTD/aOVMArzGkByG5D2bUA/N2JJhZZFwj5flo1o4=";
  };

  nativeBuildInputs = [ cmake ];

  # ref. https://github.com/cnr-isti-vclab/corto/pull/44
  postPatch = ''
    sed -e '1i #include <cstdint>' -i include/corto/tunstall.h
    sed -e '1i #include <cstdint>' -i src/meshloader.h
  '';

  meta = with lib; {
    description = "Mesh compression library, designed for rendering and speed.";
    homepage = "https://github.com/cnr-isti-vclab/corto";
    license = licenses.mit;
    maintainers = with maintainers; [ nim65s ];
  };
})
