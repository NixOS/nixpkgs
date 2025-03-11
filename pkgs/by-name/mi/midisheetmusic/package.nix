{
  lib,
  stdenv,
  fetchurl,
  mono,
  dotnetPackages,
  makeWrapper,
  gtk2,
  cups,
  timidity,
}:

let
  version = "2.6";
in
stdenv.mkDerivation {
  pname = "midisheetmusic";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/midisheetmusic/MidiSheetMusic-${version}-linux-src.tar.gz";
    sha256 = "05c6zskj50g29f51lx8fvgzsi3f31z01zj6ssjjrgr7jfs7ak70p";
  };

  nativeCheckInputs = (with dotnetPackages; [ NUnitConsole ]);
  nativeBuildInputs = [
    mono
    makeWrapper
  ];

  buildPhase = ''
    for i in Classes/MidiPlayer.cs Classes/MidiSheetMusic.cs
    do
      substituteInPlace $i --replace "/usr/bin/timidity" "${timidity}/bin/timidity"
    done

    ./build.sh
  '';

  # include missing file with unit tests for building
  # switch from mono nunit dll to standalone dll otherwise mono compiler barks
  # run via nunit3 console, because mono nunit console wants access $HOME
  checkPhase = ''
    substituteInPlace UnitTestDLL.csproj \
      --replace "</Compile>" '</Compile><Compile Include="Classes\UnitTest.cs"/>' \
      --replace nunit.framework.dll "${dotnetPackages.NUnit}/lib/dotnet/NUnit/nunit.framework.dll"
    ./build_unit_test.sh
    nunit3-console bin/Debug/UnitTest.dll
  '';

  # 2 tests of 47 are still failing
  doCheck = false;

  installPhase = ''
    mkdir -p $out/share/applications $out/share/pixmaps $out/bin

    cp deb/midisheetmusic.desktop $out/share/applications
    cp NotePair.png $out/share/pixmaps/midisheetmusic.png
    cp bin/Debug/MidiSheetMusic.exe $out/bin/.MidiSheetMusic.exe

    makeWrapper ${mono}/bin/mono $out/bin/midisheetmusic.mono.exe \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          gtk2
          cups
        ]
      } \
      --prefix PATH : ${lib.makeBinPath [ timidity ]} \
      --add-flags $out/bin/.MidiSheetMusic.exe
  '';

  meta = with lib; {
    description = "Convert MIDI Files to Piano Sheet Music for two hands";
    mainProgram = "midisheetmusic.mono.exe";
    homepage = "http://midisheetmusic.com";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
