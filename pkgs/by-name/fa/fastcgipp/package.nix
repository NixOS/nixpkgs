{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  postgresql,
  withPostgresql ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastcgipp";
  version = "3.1-unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "eddic";
    repo = "fastcgipp";
    rev = "d70b53e035511616639d900ed7e9e3e875297b86";
    hash = "sha256-qmz1o7dDXfoisO5GpfAxQXb+/687SdGp51OAhL//SHs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl ] ++ lib.optionals withPostgresql [ postgresql ];

  cmakeFlags = [
    (lib.cmakeBool "SQL" withPostgresql)
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  postPatch = ''
    # Remove -Werror to prevent build failures from warnings
    substituteInPlace CMakeLists.txt \
      --replace-fail '-Werror' ""
  '';

  # Tests require network access
  doCheck = false;

  passthru = {
    inherit withPostgresql;
  };

  meta = {
    description = "C++ FastCGI and Web development platform";
    homepage = "https://github.com/eddic/fastcgipp";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
