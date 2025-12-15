{
  lib,
  stdenv,
  fetchFromGitHub,
  zlib,
}:
stdenv.mkDerivation {
  name = "ropebwt2";
  version = "0-unstable-2021-02-01";
  src = fetchFromGitHub {
    owner = "lh3";
    repo = "ropebwt2";
    rev = "bd8dbd3db2e9e3cff74acc2907c0742c9ebbf033";
    hash = "sha256-R/VvbprwcfXF2TBZOYmc1MU3AzCcXFfWCHoYYumXtI8=";
  };
  buildInputs = [ zlib ];
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installPhase = ''
    runHook preInstall

    install -Dm755 ropebwt2 -t $out/bin

    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/lh3/ropebwt2";
    description = "Incremental construction of FM-index for DNA sequences";
    mainProgram = "ropebwt2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ apraga ];
    platforms = lib.platforms.unix;
  };
}
