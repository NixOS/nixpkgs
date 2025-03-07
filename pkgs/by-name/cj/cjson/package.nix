{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "cjson";
  version = "1.7.18";

  src = fetchFromGitHub {
    owner = "DaveGamble";
    repo = "cJSON";
    rev = "v${version}";
    sha256 = "sha256-UgUWc/+Zie2QNijxKK5GFe4Ypk97EidG8nTiiHhn5Ys=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = lib.optional (stdenv.cc.isClang && !stdenv.hostPlatform.isDarwin) (
    lib.cmakeBool "ENABLE_CUSTOM_COMPILER_FLAGS" false
  );

  # cJSON actually uses C99 standard, not C89
  # https://github.com/DaveGamble/cJSON/issues/275
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace -std=c89 -std=c99
  '';

  meta = with lib; {
    homepage = "https://github.com/DaveGamble/cJSON";
    description = "Ultralightweight JSON parser in ANSI C";
    license = licenses.mit;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.unix;
  };
}
