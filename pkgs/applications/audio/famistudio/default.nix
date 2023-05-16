{ lib
, stdenv
, fetchzip
, autoPatchelfHook
<<<<<<< HEAD
, dotnet-runtime
, ffmpeg
, libglvnd
, makeWrapper
, openal
=======
, makeWrapper
, mono
, openal
, libGL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "famistudio";
<<<<<<< HEAD
  version = "4.1.3";
=======
  version = "4.0.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchzip {
    url = "https://github.com/BleuBleu/FamiStudio/releases/download/${version}/FamiStudio${lib.strings.concatStrings (lib.splitVersion version)}-LinuxAMD64.zip";
    stripRoot = false;
<<<<<<< HEAD
    hash = "sha256-eAdv0oObczbs8QLGYbxCrdFk/gN5DOCJ1dp/tg8JWIc=";
  };

  strictDeps = true;

=======
    sha256 = "sha256-Se9EIQTjZQM5qqzlEB4hGVRHDFdu6GecNGpw9gYMbW4=";
  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
<<<<<<< HEAD
    dotnet-runtime
    ffmpeg
    libglvnd
    openal
=======
    mono
    openal
    libGL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/famistudio}
    mv * $out/lib/famistudio

<<<<<<< HEAD
    makeWrapper ${lib.getExe dotnet-runtime} $out/bin/famistudio \
      --add-flags $out/lib/famistudio/FamiStudio.dll \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libglvnd ]} \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
=======
    makeWrapper ${mono}/bin/mono $out/bin/famistudio \
      --add-flags $out/lib/famistudio/FamiStudio.exe \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
