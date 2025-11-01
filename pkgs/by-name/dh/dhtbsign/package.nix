{
  lib,
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  pname = "dhtbsign";
  version = "0-unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "osm0sis";
    repo = "dhtbsign";
    rev = "2b2711dff153485c549240423d9c908a2912f4b2";
    hash = "sha256-51zmuQ817Mqx8Hwnx/t4fC9G5huiLGIv+99nRP16mSg=";
  };

  strictDeps = true;

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optional stdenv.cc.isGNU [
      # Required with newer GCC
      "-Wno-error=stringop-overflow"
    ]
  );

  # Unstream has an install target, but installs dhtbsign as `$out/bin`
  # instead of `$out/bin/dhtbsign`
  installPhase = ''
    runHook preInstall
    install -Dm555 dhtbsign -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/osm0sis/dhtbsign";
    description = "Tool to write the DHTB header for Samsung Spreadtrum devices";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "dhtbsign";
  };
}
