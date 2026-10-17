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

  postPatch = ''
    sed -i 's/\(find_package([^ ]*\) [^ )]* QUIET)/\1)/g' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    date
    mrc
  ];

  meta = {
    homepage = "https://mhekkel.github.io/libzeep";
    description = "C++ library for reading and writing XML and creating web, REST and SOAP servers";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.boost;
  };
})
