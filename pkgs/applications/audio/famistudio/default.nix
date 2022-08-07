{ lib
, stdenv
, fetchzip
, autoPatchelfHook
, makeWrapper
, alsa-lib
, gtk-sharp-2_0
, glib
, gtk2
, mono
, openal
}:

stdenv.mkDerivation rec {
  pname = "famistudio";
  version = "3.3.1";

  src = fetchzip {
    url = "https://github.com/BleuBleu/FamiStudio/releases/download/${version}/FamiStudio${lib.strings.concatStrings (lib.splitVersion version)}-LinuxAMD64.zip";
    stripRoot = false;
    sha256 = "sha256-Bgry+cRsmC+aBff6EaeHoGBygpiZS5SmgICPU32zO+c=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ alsa-lib gtk-sharp-2_0 glib gtk2 mono openal ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib/famistudio}
    mv * $out/lib/famistudio

    makeWrapper ${mono}/bin/mono $out/bin/famistudio \
      --add-flags $out/lib/famistudio/FamiStudio.exe \
      --prefix MONO_GAC_PREFIX : ${gtk-sharp-2_0} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ glib gtk2 gtk-sharp-2_0 ]}

    # Fails to find openal32.dll on its own, needs abit of help
    rm $out/lib/famistudio/libopenal32.so
    cat <<EOF >$out/lib/famistudio/OpenTK.dll.config
    <configuration>
      <dllmap dll="openal32.dll" target="${openal}/lib/libopenal.so"/>
    </configuration>
    EOF

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
