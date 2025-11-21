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
      aarch64-darwin = "arm64";
    }
    ."${stdenv.hostPlatform.system}" or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
  hash =
    {
      x64-linux_hash = "sha256-IPF1rsK5CN4q4GtyVE2uUE79212yqX6k42hm3lO8L6U=";
      arm64-linux_hash = "sha256-/1gCHUt3sDEMkEE6vU8wNs/VAxL+exkunWiNSC5MvzY=";
      x64-osx_hash = "sha256-e+AiZoLRNv2TFTTtrhQkVr5yL5e9EQJj7nAHhLgJurI=";
      arm64-osx_hash = "sha256-724Y8IBvpAeIB07HtqSkXiyQua1jHO0jD3vjWw0kZpc=";
    }
    ."${arch}-${os}_hash";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lidarr";
  version = "3.1.0.4875";

  src = fetchurl {
    inherit hash;

    url = "https://github.com/lidarr/Lidarr/releases/download/v${finalAttrs.version}/Lidarr.master.${finalAttrs.version}.${os}-core-${arch}.tar.gz";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${finalAttrs.pname}-${finalAttrs.version}}
    cp -r * $out/share/${finalAttrs.pname}-${finalAttrs.version}/.
    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Lidarr \
      --add-flags "$out/share/${finalAttrs.pname}-${finalAttrs.version}/Lidarr.dll" \
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
    tests.smoke-test = nixosTests.lidarr;
  };

  meta = {
    description = "Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ramonacat ];
    mainProgram = "Lidarr";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})
