{
  lib,
  stdenv,
  fetchurl,
  mono,
  unzip,
  runCommand,
  mkNugetDeps,
  makeWrapper,
  makeFontsConf,
  gtk2,
  cups,
  timidity,
}:

let
  deps = mkNugetDeps {
    name = "midisheetmusic-deps";
    nugetDeps =
      { fetchNuGet }:
      [
        (fetchNuGet {
          pname = "NUnit.Console";
          version = "3.0.1";
          sha256 = "154bqwm2n95syv8nwd67qh8qsv0b0h5zap60sk64z3kd3a9ffi5p";
        })
        (fetchNuGet {
          pname = "NUnit";
          version = "2.6.4";
          sha256 = "1acwsm7p93b1hzfb83ia33145x0w6fvdsfjm9xflsisljxpdx35y";
        })
      ];
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "midisheetmusic";
  version = "2.6";

  src = fetchurl {
    url = "mirror://sourceforge/midisheetmusic/MidiSheetMusic-${finalAttrs.version}-linux-src.tar.gz";
    sha256 = "05c6zskj50g29f51lx8fvgzsi3f31z01zj6ssjjrgr7jfs7ak70p";
  };

  nativeBuildInputs = [
    mono
    makeWrapper
  ];

  buildPhase = ''
    for i in Classes/MidiPlayer.cs Classes/MidiSheetMusic.cs
    do
      substituteInPlace $i --replace-fail "/usr/bin/timidity" "${timidity}/bin/timidity"
    done

    ./build.sh
  '';

  doCheck = true;

  checkPhase = ''
    # Resolves the warning "Fontconfig error: No writable cache directories"
    export XDG_CACHE_HOME="$(mktemp -d)"

    # Adds one file with tests that's missing from compiliation
    # Makes sure NUnit framework from NuGet can be found
    substituteInPlace UnitTestDLL.csproj \
      --replace-fail '</Compile>' '</Compile><Compile Include="Classes\UnitTest.cs"/>' \
      --replace-fail 'nunit.framework.dll' '${deps}/share/nuget/packages/nunit/2.6.4/lib/nunit.framework.dll'
    ./build_unit_test.sh

    # 2 tests are still failing, we exclude them for now
    mono ${deps}/share/nuget/packages/nunit.console/3.0.1/tools/nunit3-console.exe bin/Debug/UnitTest.dll \
      --where "test != 'MidiFileTest.TestChangeSoundTrack' && test != 'MidiFileTest.TestChangeSoundPerChannelTracks'"
  '';

  # This fixes tests that fail because of missing fonts
  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ ]; };

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

  meta = {
    description = "Convert MIDI Files to Piano Sheet Music for two hands";
    mainProgram = "midisheetmusic.mono.exe";
    homepage = "http://midisheetmusic.com";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.mdarocha ];
    platforms = lib.platforms.linux;
  };
})
