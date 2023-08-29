{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, dotnet-runtime
, ffmpeg
, libglvnd
, makeWrapper
, openal
}:

stdenv.mkDerivation rec {
  pname = "famistudio";
  version = "4.1.2";

  src = fetchzip {
    url = "https://github.com/BleuBleu/FamiStudio/releases/download/${version}/FamiStudio${lib.strings.concatStrings (lib.splitVersion version)}-LinuxAMD64.zip";
    stripRoot = false;
    hash = "sha256-zETivzQBkKOhsZryiwv3dDeXPO8CKWFfjERdPJXbj5U=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    dotnet-runtime
    ffmpeg
    libglvnd
    openal
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/famistudio}
    mv * $out/lib/famistudio

    makeWrapper ${lib.getExe dotnet-runtime} $out/bin/famistudio \
      --add-flags $out/lib/famistudio/FamiStudio.dll \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]} \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}

    # Bundled openal lib freezes the application
    rm $out/lib/famistudio/libopenal32.so
    ln -s ${openal}/lib/libopenal.so $out/lib/famistudio/libopenal32.so

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://famistudio.org/";
    description = "NES Music Editor";
    longDescription = ''
      FamiStudio is very simple music editor for the Nintendo Entertainment System
      or Famicom. It is targeted at both chiptune artists and NES homebrewers.
    '';
    license = licenses.mit;
    # Maybe possible to build from source but I'm not too familiar with C# packaging
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = [ "x86_64-linux" ];
  };
}
