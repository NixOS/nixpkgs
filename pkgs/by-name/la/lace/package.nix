{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "lace";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "trolando";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-yWlRkEvR7k322MlZVj5X062TsuSquPQd4TmFv7ufUc4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Implementation of work-stealing in C";
    homepage = "https://github.com/trolando/lace";
    maintainers = [ maintainers.mgttlinger ];
    license = licenses.asl20;
    platforms = with platforms; linux ++ darwin ++ windows;
  };
}
