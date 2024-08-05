{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  date,
  mrc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "libzeep";
  version = "6.0.13";

  src = fetchFromGitHub {
    owner = "mhekkel";
    repo = "libzeep";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-74mYjz/jXzEU3j1kHSvTvZcIfX9csVJKTKONAZXUMvs=";
  };

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "3.0.1 QUIET" ""
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost date mrc ];

  meta = {
    homepage = "https://mhekkel.github.io/libzeep";
    description = "C++ library for reading and writing XML and creating web, REST and SOAP servers";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.bsd2;
  };
})
