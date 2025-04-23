{
  lib,
  stdenv,
  fetchurl,
  mono,
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
  pname = "prowlarr";

  unsupported = throw "Unsupported system ${stdenv.hostPlatform.system} for ${pname}";

  os =
    if stdenv.hostPlatform.isDarwin then
      "osx"
    else if stdenv.hostPlatform.isLinux then
      "linux"
    else
      unsupported;

  arch =
    {
      aarch64-darwin = "arm64";
      aarch64-linux = "arm64";
      x86_64-darwin = "x64";
      x86_64-linux = "x64";
    }
    .${stdenv.hostPlatform.system} or unsupported;

  hash =
    {
      aarch64-darwin = "sha256-glN+QlawtpG9aZ2ROCRkDjNCLTLh8IUWs695XShDhzI=";
      aarch64-linux = "sha256-oyeZrUC2l5O62fknNBdfwEH3p2tFXX8fFrEaA7vWoRg=";
      x86_64-darwin = "sha256-58io1d+mKcXvcoMQzGBIOQg2b6ehLQS2G6r0RnR+blw=";
      x86_64-linux = "sha256-8owcCOPSKfZrAxeuGT8dZnmnbAtQiyv12K9Yr0KJhQE=";
    }
    .${stdenv.hostPlatform.system} or unsupported;
in
stdenv.mkDerivation rec {
  inherit pname;
  version = "1.33.3.5008";

  src = fetchurl {
    url = "https://github.com/Prowlarr/Prowlarr/releases/download/v${version}/Prowlarr.master.${version}.${os}-core-${arch}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/${pname}-${version}}
    cp -r * $out/share/${pname}-${version}/.

    makeWrapper "${dotnet-runtime}/bin/dotnet" $out/bin/Prowlarr \
      --add-flags "$out/share/${pname}-${version}/Prowlarr.dll" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          curl
          sqlite
          libmediainfo
          mono
          openssl
          icu
          zlib
        ]
      }

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.smoke-test = nixosTests.prowlarr;
  };

  meta = with lib; {
    description = "Indexer manager/proxy built on the popular arr .net/reactjs base stack";
    homepage = "https://wiki.servarr.com/prowlarr";
    changelog = "https://github.com/Prowlarr/Prowlarr/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ pizzapim ];
    mainProgram = "Prowlarr";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
