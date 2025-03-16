{ lib
, stdenv
, fetchurl
, sqlite
, libGL
, libpng
, libgcc
, zlib
, unzip
, autoPatchelfHook
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "minifox";
  version = "0.11";

  src = fetchurl {
    url = "https://github.com/openfoxwq/openfoxwq.github.io/releases/download/v${version}/minifox-v${version}-linux.zip";
    hash = "sha256-TG516VY3+5E8Sb0C9JpxGjlY71NTc2AerJkD944c9ls=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    unzip
  ];

  buildInputs = [
    makeWrapper
    libGL
    sqlite
    zlib
    libpng
    libgcc
    stdenv.cc.cc.lib
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    install -m755 -D minifox $out/bin/minifox
    install -m755 -D -d asset $out/bin/asset
    for file in $(find asset -type f); do
      install -m 644 -D $file $out/bin/$file
    done

    wrapProgram "$out/bin/minifox" --run 'export MINIFOXWQ_DATA_DIR="$HOME/.openfoxwq"' --run 'mkdir -p "$HOME/.openfoxwq"'
  '';

  meta = with lib; {
    homepage = "https://openfoxwq.github.io/";
    description = "MiniFox third party unofficial client for Fox Go server";
    platforms = platforms.linux;
    mainProgram = "minifox";
    maintainers = [ maintainers.mcoll ];
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
