{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, mono
, openal
, libGL
}:

stdenv.mkDerivation rec {
  pname = "famistudio";
  version = "4.0.1";

  src = fetchzip {
    url = "https://github.com/BleuBleu/FamiStudio/releases/download/${version}/FamiStudio${lib.strings.concatStrings (lib.splitVersion version)}-LinuxAMD64.zip";
    stripRoot = false;
    sha256 = "sha256-pAULW2aIaKiA61rARpL+hSoffnQO6hfqVpOcEMwD7oo=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    mono
    openal
    libGL
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/famistudio}
    mv * $out/lib/famistudio

    makeWrapper ${mono}/bin/mono $out/bin/famistudio \
      --add-flags $out/lib/famistudio/FamiStudio.exe \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}

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
