{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, darwin
}:

stdenv.mkDerivation rec {
  pname = "qgrep";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "zeux";
    repo = "qgrep";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-TeXOzfb1Nu6hz9l6dXGZY+xboscPapKm0Z264hv1Aww=";
  };

  patches = [
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/zeux/qgrep/commit/8810ab153ec59717a5d7537b3e7812c01cd80848.patch";
      hash = "sha256-lCMvpuLZluT6Rw8RFZ2uY9bffPBoq6sRVWYLUmeXfOg=";
    })
  ];

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  env.NIX_CFLAGS_COMPILE = toString (lib.optionals stdenv.isDarwin [
    "-Wno-error=unused-command-line-argument"
    "-Wno-error=unqualified-std-cast-call"
  ]);

  installPhase = ''
    runHook preInstall

    install -Dm755 qgrep $out/bin/qgrep

    runHook postInstall
  '';

  meta = with lib; {
    description = "Fast regular expression grep for source code with incremental index updates";
    homepage = "https://github.com/zeux/qgrep";
    license = licenses.mit;
    maintainers = [ maintainers.yrashk ];
    platforms = platforms.all;
  };
}
