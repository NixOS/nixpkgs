{
  lib,
  buildDotnetModule,
  fetchurl,
  unzip,
  dos2unix,
  msbuild,
  mono,
  dotnetCorePackages,
}:
buildDotnetModule rec {
  pname = "networkminer";
  version = "3.0";

  src =
    let
      version' = lib.replaceString "." "-" version;
    in
    fetchurl {
      # Upstream does not provide versioned releases, a mirror has been uploaded
      # to archive.org
      # Non-versioned download link can be found on https://www.netresec.com/?page=NetworkMinerSourceCode
      url = "https://archive.org/download/network-miner-${version'}-source/NetworkMiner_${version'}_source.zip";
      hash = "sha256-I5VtpfmlYO0+K1WtwouP0lzJptpE0sHn5JeCBTnXdio=";
    };

  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  nativeBuildInputs = [
    unzip
    dos2unix
    msbuild
  ];

  postPatch = ''
    # Not all files have UTF-8 BOM applied consistently
    find . -type f -exec dos2unix -m {} \+

    # Embedded base64-encoded app icon in resx fails to parse. Delete it
    sed -zi 's|<data name="$this.Icon".*</data>||g' NetworkMiner/NamedPipeForm.resx
    sed -zi 's|<data name="$this.Icon".*</data>||g' NetworkMiner/UpdateCheck.resx
  '';

  nugetDeps = ./deps.json;

  buildPhase = ''
    runHook preBuild

    msbuild /p:Configuration=Release NetworkMiner.sln

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
    cp -r NetworkMiner/bin/Release $out/share/NetworkMiner
    makeWrapper ${mono}/bin/mono $out/bin/NetworkMiner \
      --add-flags "$out/share/NetworkMiner/NetworkMiner.exe" \
      --add-flags "--noupdatecheck"

    install -D NetworkMiner/NetworkMiner.desktop $out/share/applications/NetworkMiner.desktop
    substituteInPlace $out/share/applications/NetworkMiner.desktop \
      --replace-fail "Icon=./Images/NetworkMiner_logo_313x313.png" "Icon=NetworkMiner"
    install -D NetworkMiner/networkminericon-96x96.png $out/share/pixmaps/NetworkMiner.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open Source Network Forensic Analysis Tool (NFAT)";
    homepage = "https://www.netresec.com/?page=NetworkMiner";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.linux;
    mainProgram = "NetworkMiner";
  };
}
