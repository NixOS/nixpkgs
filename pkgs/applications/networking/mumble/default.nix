{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  qt5,
  cmake,
  ninja,
  avahi,
  boost,
  libopus,
  libsndfile,
  protobuf,
  libcap,
  utf8proc,
  alsa-lib,
  python3,
  rnnoise,
  nixosTests,
  poco,
  flac,
  libogg,
  libvorbis,
  stdenv_32bit,
  iceSupport ? true,
  zeroc-ice,
  jackSupport ? false,
  libjack2,
  pipewireSupport ? true,
  pipewire,
  pulseSupport ? true,
  libpulseaudio,
  speechdSupport ? false,
  speechd-minimal,
  microsoft-gsl,
  nlohmann_json,
}:

let
  generic =
    overrides: source:
    (overrides.stdenv or stdenv).mkDerivation (
      source
      // overrides
      // {
        pname = overrides.type;
        version = source.version;

        nativeBuildInputs = [
          cmake
          ninja
          pkg-config
          python3
          qt5.wrapQtAppsHook
          qt5.qttools
        ] ++ (overrides.nativeBuildInputs or [ ]);

        buildInputs = [
          avahi
          boost
          poco
          protobuf
        ] ++ (overrides.buildInputs or [ ]);

        cmakeFlags = [
          (lib.cmakeBool "g15" false)
          (lib.cmakeFeature "CMAKE_CXX_STANDARD" "17") # protobuf >22 requires C++ 17
          (lib.cmakeBool "CMAKE_UNITY_BUILD" true) # Upstream uses this in their build pipeline to speed up builds
        ] ++ (overrides.cmakeFlags or [ ]);

        preConfigure = ''
          patchShebangs scripts
        '';

        passthru.tests.connectivity = nixosTests.mumble;

        meta = with lib; {
          description = "Low-latency, high quality voice chat software";
          homepage = "https://mumble.info";
          license = licenses.bsd3;
          maintainers = with maintainers; [
            felixsinger
            lilacious
          ];
          platforms = platforms.linux;
        };
      }
    );

  client =
    source:
    generic {
      type = "mumble";

      nativeBuildInputs = [ qt5.qttools ];
      buildInputs =
        [
          flac
          libogg
          libopus
          libsndfile
          libvorbis
          qt5.qtsvg
          rnnoise
          utf8proc
          microsoft-gsl
          nlohmann_json
        ]
        ++ lib.optional (!jackSupport) alsa-lib
        ++ lib.optional jackSupport libjack2
        ++ lib.optional speechdSupport speechd-minimal
        ++ lib.optional pulseSupport libpulseaudio
        ++ lib.optional pipewireSupport pipewire
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          xar
          makeWrapper
        ];


      cmakeFlags = [
        (lib.cmakeBool "server" false)
        (lib.cmakeBool "bundle-qt-translations" false)
        (lib.cmakeBool "bundled-json" false)
        (lib.cmakeBool "bundled-gsl" false)
        # (lib.cmakeBool "bundled-renamenoise" false) # not packaged in nixpkgs yet
        (lib.cmakeBool "update" false)
        (lib.cmakeBool "oss" false)
        (lib.cmakeBool "warnings-as-errors" false) # conversion error workaround
        (lib.cmakeBool "speechd" speechdSupport)
        (lib.cmakeBool "pulseaudio" pulseSupport)
        (lib.cmakeBool "pipewire" pipewireSupport)
        (lib.cmakeBool "jackaudio" jackSupport)
        (lib.cmakeBool "alsa" (!jackSupport))
      ];

      env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd-minimal}/include/speech-dispatcher";

      postFixup = ''
        wrapProgram $out/bin/mumble \
          --prefix LD_LIBRARY_PATH : "${
            lib.makeLibraryPath (
              lib.optional pulseSupport libpulseaudio ++ lib.optional pipewireSupport pipewire
            )
          }"
      '';
    } source;

  server =
    source:
    generic {
      type = "murmur";

      cmakeFlags =
        [
          (lib.cmakeBool "client" false)
          (lib.cmakeBool "ice" iceSupport)
        ]
        ++ lib.optionals iceSupport [
          (lib.cmakeFeature "Ice_HOME" "${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}")
          (lib.cmakeFeature "CMAKE_PREFIX_PATH" "${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}")
          (lib.cmakeFeature "Ice_SLICE_DIR" "${lib.getDev zeroc-ice}/share/ice/slice")
        ];

      buildInputs = [ libcap ] ++ lib.optional iceSupport zeroc-ice;
    } source;

  overlay =
    source:
    generic {
      stdenv = stdenv_32bit;
      type = "mumble-overlay";

      cmakeFlags = [
        (lib.cmakeBool "server" false)
        (lib.cmakeBool "client" false)
        (lib.cmakeBool "overlay" true)
      ];
    } source;

  source = rec {
    version = "1.5.735";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      rev = "v${version}";
      hash = "sha256-JRnGgxkf5ct6P71bYgLbCEUmotDLS2Evy6t8R7ac7D4=";
      fetchSubmodules = true;
    };
  };
in
{
  mumble = lib.recursiveUpdate (client source) { meta.mainProgram = "mumble"; };
  murmur = lib.recursiveUpdate (server source) { meta.mainProgram = "mumble-server"; };
  # What is this meant to be used for? It's not used in nixpkgs.
  overlay = overlay source;
}
