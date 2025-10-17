{
  stdenvNoCC,
  lib,
  buildDotnetModule,
  dotnetCorePackages,
  callPackage,
  fetchFromGitHub,
  ffmpeg,
  glfw,
  gtk3,
  libglvnd,
  libogg,
  libvorbis,
  openal,
  portaudio,
  rtmidi,
  _experimental-update-script-combinators,
  gitUpdater,
}:

let
  csprojName =
    if stdenvNoCC.hostPlatform.isLinux then
      "FamiStudio.Linux"
    else if stdenvNoCC.hostPlatform.isDarwin then
      "FamiStudio.Mac"
    else
      throw "Don't know how to build FamiStudio for ${stdenvNoCC.hostPlatform.system}";
in
buildDotnetModule (finalAttrs: {
  pname = "famistudio";
  version = "4.4.2";

  src = fetchFromGitHub {
    owner = "BleuBleu";
    repo = "FamiStudio";
    tag = finalAttrs.version;
    hash = "sha256-A4tC1khtCLTfacdEq5z8ulRzhoItNgBe438TAaPdyLA=";
  };

  postPatch =
    let
      libname = library: "${library}${stdenvNoCC.hostPlatform.extensions.sharedLibrary}";
      buildNativeWrapper =
        args:
        callPackage ./build-native-wrapper.nix (
          args
          // {
            inherit (finalAttrs) version src;
            sourceRoot = "${finalAttrs.src.name}/ThirdParty/${args.depname}";
          }
        );
      nativeWrapperToReplaceFormat =
        args:
        let
          libPrefix = lib.optionalString stdenvNoCC.hostPlatform.isLinux "lib";
        in
        {
          package = buildNativeWrapper args;
          expectedName = "${libPrefix}${args.depname}";
          ourName = "${libPrefix}${args.depname}";
        };
      librariesToReplace = [
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
      ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [
        {
          package = openal;
          expectedName = "libopenal32";
          ourName = "libopenal";
        }
      ]
      ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
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
      substituteInPlace ${finalAttrs.projectFile} ${libraryReplaceArgs}

      # Un-hardcode target platform if set
      sed -i -e '/PlatformTarget/d' ${finalAttrs.projectFile}

      # Don't require a special name to be preserved, our OpenAL isn't 32-bit
      substituteInPlace FamiStudio/Source/AudioStreams/OpenALStream.cs \
        --replace-fail 'libopenal32' 'libopenal'
    '';

  projectFile = "FamiStudio/${csprojName}.csproj";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;

  runtimeDeps = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    gtk3
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

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (gitUpdater { }).command
    (finalAttrs.passthru.fetch-deps)
  ];

  meta = {
    homepage = "https://famistudio.org/";
    description = "NES Music Editor";
    longDescription = ''
      FamiStudio is very simple music editor for the Nintendo Entertainment System
      or Famicom. It is targeted at both chiptune artists and NES homebrewers.
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      OPNA2608
    ];
    platforms = lib.platforms.unix;
    mainProgram = "FamiStudio";
  };
})
