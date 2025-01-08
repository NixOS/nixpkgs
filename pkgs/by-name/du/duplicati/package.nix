{
  lib,
  stdenv,
  fetchzip,
  mono,
  sqlite,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "duplicati";
  version = "2.1.0.2";
  channel = "beta";
  build_date = "2024-11-29";

  src = fetchzip {
    url =
      with finalAttrs;
      "https://github.com/duplicati/duplicati/releases/download/v${version}-${version}_${channel}_${build_date}/duplicati-${version}_${channel}_${build_date}.zip";
    hash = "sha256-LmW6yGutxP33ghFqyOLKrGDNCQdr8DDFn/IHigsLpzA=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/{bin,share/duplicati-${finalAttrs.version}}
    cp -r * $out/share/duplicati-${finalAttrs.version}
    makeWrapper "${lib.getExe mono}" $out/bin/duplicati-cli \
      --add-flags "$out/share/duplicati-${finalAttrs.version}/Duplicati.CommandLine.exe" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          sqlite
        ]
      }
    makeWrapper "${lib.getExe mono}" $out/bin/duplicati-server \
      --add-flags "$out/share/duplicati-${finalAttrs.version}/Duplicati.Server.exe" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          sqlite
        ]
      }
  '';

  meta = {
    description = "Free backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers";
    homepage = "https://www.duplicati.com/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [
      nyanloutre
      bot-wxt1221
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = lib.platforms.all;
  };
})
