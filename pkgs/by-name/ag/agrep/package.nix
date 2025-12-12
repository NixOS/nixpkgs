{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenv,
}:
let
  # This repository has numbered versions, but not Git tags.
  rev = "b7d180fe73636740f694ec60c1ffab52b06e7150";
in
stdenv.mkDerivation {
  pname = "agrep";
  version = "3.41.5-unstable-2022-03-23";

  src = fetchFromGitHub {
    inherit rev;
    owner = "Wikinaut";
    repo = "agrep";
    hash = "sha256-2J4bw5BVZgTEcIn9IuD5Q8/L+8tldDbToDefuxDf85g=";
  };

  patches = [
    # Implicit declaration of functions & implicit int
    # https://github.com/Wikinaut/agrep/pull/31
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/Wikinaut/agrep/pull/31.patch";
      hash = "sha256-9ik2RANq12T/1vCUYTBNomzw+aJVa/LU2RsZovu3r3E=";
    })
  ];

  postPatch = ''
    # agrep only doesn't includes <sys/stat.h> for Linux
    # Starting from gcc14, this is a compiler error
    substituteInPlace checkfil.c recursiv.c \
      --replace-fail '#ifdef __APPLE__
        #include <sys/stat.h>
    #endif' '#include <sys/stat.h>'

    substituteInPlace newmgrep.c \
      --replace-fail '#if defined(_WIN32) || defined(__APPLE__)
        #include <sys/stat.h>
    #endif' '#include <sys/stat.h>'
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-std=c89";

  installPhase = ''
    runHook preInstall

    install -Dm 555 agrep -t "$out/bin"
    install -Dm 444 docs/* -t "$out/doc"

    runHook postInstall
  '';

  meta = {
    description = "Approximate grep for fast fuzzy string searching";
    mainProgram = "agrep";
    homepage = "https://www.tgries.de/agrep/";
    maintainers = with lib.maintainers; [ momeemt ];
    changelog = "https://github.com/Wikinaut/agrep/blob/${rev}/CHANGES";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
  };
}
