{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  eigen,
  asio,
  boost,
}:

let
  # Very recent library, probably specific to glaze, by the same author
  #
  # Description: "A stripped down fork of boost-ext ut2"
  # Homepage: "https://github.com/openalgz/ut"
  ut_src = fetchFromGitHub {
    owner = "openalgz";
    repo = "ut";
    rev = "v0.0.3";
    hash = "sha256-lhq8Wy/Y7yehs5KgMAvLvsu09YCO6LPabfkjSDH56/Y=";
  };
in

stdenv.mkDerivation rec {
  pname = "glaze";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "stephenberry";
    repo = "glaze";
    rev = "v${version}";
    hash = "sha256-zaGKYEnYTyAhtP0Hywxp8Y33wvjB1RkEoOGF41CaVnY=";
  };

  patches = [ ./0001-Do-not-fetch-external-resources-via-Git.patch ];

  postPatch = ''
    substituteInPlace tests/CMakeLists.txt --subst-var-by UT_DIR ${ut_src}

    mkdir -p $TMPDIR/asio
    tar xf ${asio.src} -C $TMPDIR/asio --strip-components 1
    substituteInPlace tests/asio_repe/CMakeLists.txt --subst-var-by ASIO_DIR $TMPDIR/asio
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

  doCheck = true;

  checkInputs = [ eigen ];

  meta = with lib; {
    description = "Extremely fast, in memory, JSON and interface library for modern C++";
    homepage = "https://github.com/stephenberry/glaze";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ panicgh ];
  };
}
