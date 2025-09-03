{
  lib,
  stdenv,
  fetchurl,
  mono,
  libmediainfo,
  sqlite,
  curl,
  chromaprint,
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
      x64-linux_hash = "sha256-24bNK4iHgaobxYpy+OJAocGugV0CwF3q1ND6maEaYSY=";
      arm64-linux_hash = "sha256-ck2AspRkKm8hdzO70acTGUUd8WTOevIJF50YwQf/R20=";
      x64-osx_hash = "sha256-ut/4154i/yKlm2JacgW9jvevDniedzLudfeuUXV9XzM=";
      arm64-osx_hash = "sha256-/aIusVUmsqLCNNhosCAVbR5oN6oLROEuJKnH22cRXfo=";
    }
    ."${arch}-${os}_hash";
in
stdenv.mkDerivation rec {
  pname = "lidarr";
  version = "2.13.3.4711";

  src = fetchurl {
    url = "https://github.com/lidarr/Lidarr/releases/download/v${version}/Lidarr.master.${version}.${os}-core-${arch}.tar.gz";
    sha256 = hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.
    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Lidarr \
      --add-flags "$out/share/${pname}-${version}/Lidarr.dll" \
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

  meta = with lib; {
    description = "Usenet/BitTorrent music downloader";
    homepage = "https://lidarr.audio/";
    license = licenses.gpl3;
    maintainers = [ ];
    mainProgram = "Lidarr";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
