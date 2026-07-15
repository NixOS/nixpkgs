{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ck";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "concurrencykit";
    repo = "ck";
    rev = finalAttrs.version;
    sha256 = "sha256-lxJ8WsZ3pBGf4sFYj5+tR37EYDZqpksaoohiIKA4pRI=";
  };

  postPatch = ''
    substituteInPlace \
      configure \
        --replace \
          'COMPILER=`./.1 2> /dev/null`' \
          "COMPILER=gcc"
  '';

  configureFlags = [ "--platform=${stdenv.hostPlatform.parsed.cpu.name}}" ];

  dontDisableStatic = true;

  meta = {
    description = "High-performance concurrency research library";
    longDescription = ''
      Concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems.
    '';
    license = with lib.licenses; [
      asl20
      bsd2
    ];
    homepage = "https://concurrencykit.org/";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      chessai
      thoughtpolice
    ];
  };
})
