{
  lib,
  stdenv,
  fetchurl,
  libmediainfo,
  sqlite,
  curl,
  makeWrapper,
  icu,
  dotnet-runtime,
  openssl,
  nixosTests,
  zlib,
}:

let
  os = if stdenv.hostPlatform.isDarwin then "osx" else "linux";
  arch =
    {
      x86_64-linux = "x64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash =
    {
      x64-linux_hash = "sha256-a3GEZTD3wcg8hz3wNrNMU13939C10S3gfRoNPfMBuAE=";
      arm64-linux_hash = "sha256-nqnNgds1VWf6MiryQS6hJzg8bi1Ckegf0CsC8dfqDTY=";
      x64-osx_hash = "sha256-IiW8pwLfcpbDGSO0DQhp2+J+tG5EvXth0fi6Z5q/d4c=";
    }
    ."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "readarr";
  version = "0.4.10.2734";

  src = fetchurl {
    url = "https://github.com/Readarr/Readarr/releases/download/v${version}/Readarr.develop.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.
    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Readarr \
      --add-flags "$out/share/${pname}-${version}/Readarr.dll" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          curl
          sqlite
          libmediainfo
          icu
          openssl
          zlib
        ]
      }

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.readarr;
  };

  meta = {
    description = "Usenet/BitTorrent ebook downloader";
    homepage = "https://readarr.com";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      jocelynthode
      devusb
    ];
    mainProgram = "Readarr";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
    ];
  };
}
