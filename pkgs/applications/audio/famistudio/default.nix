{
  stdenv,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  callPackage,
  fetchFromGitHub,
  ffmpeg,
  glfw,
  libglvnd,
  libogg,
  libvorbis,
  makeWrapper,
  openal,
  portaudio,
  rtmidi,
}:

let
  csprojName =
    if stdenv.hostPlatform.isLinux then
      "FamiStudio.Linux"
    else if stdenv.hostPlatform.isDarwin then
      "FamiStudio.Mac"
    else
      throw "Don't know how to build FamiStudio for ${stdenv.hostPlatform.system}";
in
buildDotnetModule rec {
  pname = "famistudio";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "BleuBleu";
    repo = "FamiStudio";
    rev = "refs/tags/${version}";
    hash = "sha256-ydEWLL05B86672j3MVo/90tgDHg8FJ2EZaesqrBZy4A=";
  };

  postPatch =
    let
      libname = library: "${library}${stdenv.hostPlatform.extensions.sharedLibrary}";
      buildNativeWrapper =
        args:
        callPackage ./build-native-wrapper.nix (
          args
          // {
            inherit version src;
            sourceRoot = "${src.name}/ThirdParty/${args.depname}";
          }
        );
      nativeWrapperToReplaceFormat =
        args:
        let
          libPrefix = lib.optionalString stdenv.hostPlatform.isLinux "lib";
        in
        {
          package = buildNativeWrapper args;
          expectedName = "${libPrefix}${args.depname}";
          ourName = "${libPrefix}${args.depname}";
        };
      librariesToReplace =
        [
          # Unmodified native libraries that we can fully substitute
          {
            package = glfw;
            expectedName = "libglfw";
            ourName = "libglfw";
          }
          {
            package = rtmidi;
            expectedName = "librtmidi";
            ourName = "librtmidi";
          }
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
          {
            package = openal;
            expectedName = "libopenal32";
            ourName = "libopenal";
          }
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          {
            package = portaudio;
            expectedName = "libportaudio.2";
            ourName = "libportaudio.2";
          }
        ]
        ++ [
          # Native libraries, with extra code for the C# wrapping
          (nativeWrapperToReplaceFormat { depname = "GifDec"; })
          (nativeWrapperToReplaceFormat { depname = "NesSndEmu"; })
          (nativeWrapperToReplaceFormat {
            depname = "NotSoFatso";
            extraPostPatch = ''
              # C++17 does not allow register storage class specifier
              substituteInPlace build.sh \
                --replace-fail "$CXX" "$CXX -std=c++14"
            '';
          })
          (nativeWrapperToReplaceFormat { depname = "ShineMp3"; })
          (nativeWrapperToReplaceFormat { depname = "Stb"; })
          (nativeWrapperToReplaceFormat {
            depname = "Vorbis";
            buildInputs = [
              libogg
              libvorbis
            ];
          })
        ];
      libraryReplaceArgs = lib.strings.concatMapStringsSep " " (
        library:
        "--replace-fail '${libname library.expectedName}' '${lib.getLib library.package}/lib/${libname library.ourName}'"
      ) librariesToReplace;
    in
    ''
      # Don't use any prebuilt libraries
      rm FamiStudio/*.{dll,dylib,so*}

      # Replace copying of vendored prebuilt native libraries with copying of our native libraries
      substituteInPlace ${projectFile} ${libraryReplaceArgs}

      # Un-hardcode target platform if set
      sed -i -e '/PlatformTarget/d' ${projectFile}

      # Don't require a special name to be preserved, our OpenAL isn't 32-bit
      substituteInPlace FamiStudio/Source/AudioStreams/OpenALStream.cs \
        --replace-fail 'libopenal32' 'libopenal'
    '';

  projectFile = "FamiStudio/${csprojName}.csproj";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_7_0;
  dotnet-runtime = dotnetCorePackages.runtime_7_0;

  runtimeDeps = lib.optionals stdenv.hostPlatform.isLinux [
    libglvnd
  ];

  executables = [ "FamiStudio" ];

  postInstall = ''
    mkdir -p $out/share/famistudio
    for datdir in Setup/Demo\ {Instruments,Songs}; do
      cp -R "$datdir" $out/share/famistudio/
    done
  '';

  postFixup = ''
    # FFMpeg looked up from PATH
    wrapProgram $out/bin/FamiStudio \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    homepage = "https://famistudio.org/";
    description = "NES Music Editor";
    longDescription = ''
      FamiStudio is very simple music editor for the Nintendo Entertainment System
      or Famicom. It is targeted at both chiptune artists and NES homebrewers.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.unix;
    mainProgram = "FamiStudio";
  };
}
