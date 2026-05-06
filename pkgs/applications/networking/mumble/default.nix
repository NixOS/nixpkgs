{
  cli11,
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  cmake,
  ninja,
  avahi,
  boost,
  libopus,
  libsndfile,
  speexdsp,
  protobuf,
  libcap,
  alsa-lib,
  python3,
  rnnoise,
  nixosTests,
  poco,
  flac,
  libogg,
  libvorbis,
  stdenv_32bit,
  alsaSupport ? stdenv.hostPlatform.isLinux,
  iceSupport ? true,
  zeroc-ice,
  jackSupport ? false,
  libjack2,
  pipewireSupport ? stdenv.hostPlatform.isLinux,
  pipewire,
  pulseSupport ? true,
  libpulseaudio,
  speechdSupport ? false,
  speechd-minimal,
  nlohmann_json,
  xar,
  makeBinaryWrapper,
  postgresql,
  spdlog,
  utfcpp,
  serverMysqlSupport ? false,
  serverPostgresqlSupport ? true,
  serverSqliteSupport ? true,
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
          qt6.wrapQtAppsHook
          qt6.qttools
          makeBinaryWrapper
        ]
        ++ (overrides.nativeBuildInputs or [ ]);

        buildInputs = [
          boost
          cli11
          poco
          protobuf
          nlohmann_json
          spdlog
          utfcpp
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ avahi ]
        ++ (overrides.buildInputs or [ ]);

        cmakeFlags = [
          "-D g15=OFF"
          "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
          "-D BUILD_NUMBER=${lib.versions.patch source.version}"
          "-D CMAKE_UNITY_BUILD=ON" # Upstream uses this in their build pipeline to speed up builds
          "-D bundled-json=OFF"
          "-D warnings-as-errors=OFF" # protobuf 34.x `[[nodiscard]]` workaround https://github.com/mumble-voip/mumble/issues/7102
          "-D use-timestamps=OFF"
          "-D bundled-cli11=OFF"
          "-D bundled-spdlog=OFF"
          "-D bundled-utfcpp=OFF"
        ]
        ++ (overrides.cmakeFlags or [ ]);

        preConfigure = ''
          patchShebangs scripts
        '';

        passthru.tests.connectivity = nixosTests.mumble;

        meta = {
          description = "Low-latency, high quality voice chat software";
          homepage = "https://mumble.info";
          license = lib.licenses.bsd3;
          maintainers = with lib.maintainers; [
            felixsinger
            lilacious
          ];
          platforms = lib.platforms.linux ++ (overrides.platforms or [ ]);
        };
      }
    );

  client =
    source:
    generic {
      type = "mumble";

      platforms = lib.platforms.darwin;
      nativeBuildInputs = [
        qt6.qttools
      ];

      buildInputs = [
        flac
        libogg
        libopus
        libsndfile
        libvorbis
        speexdsp
        qt6.qtsvg
        rnnoise
      ]
      ++ lib.optional (!jackSupport && alsaSupport) alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional speechdSupport speechd-minimal
      ++ lib.optional pulseSupport libpulseaudio
      ++ lib.optional pipewireSupport pipewire
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        xar
      ];

      cmakeFlags = [
        "-D server=OFF"
        "-D bundled-speex=OFF"
        "-D bundled-rnnoise=OFF"
        "-D bundle-qt-translations=OFF"
        "-D update=OFF"
        "-D overlay-xcompile=OFF"
        "-D oss=OFF"
        "-D warnings-as-errors=OFF" # `std::wstring_convert` deprecation workaround
        # building the overlay on darwin does not work in nipxkgs (yet)
        # also see the patch below to disable scripts the build option misses
        # see https://github.com/mumble-voip/mumble/issues/6816
        (lib.cmakeBool "overlay" (!stdenv.hostPlatform.isDarwin))
        (lib.cmakeBool "speechd" speechdSupport)
        (lib.cmakeBool "pulseaudio" pulseSupport)
        (lib.cmakeBool "pipewire" pipewireSupport)
        (lib.cmakeBool "jackaudio" jackSupport)
        (lib.cmakeBool "alsa" (!jackSupport && alsaSupport))
      ];

      env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd-minimal}/include/speech-dispatcher";

      patches = [
        ./fix-plugin-copy.patch
      ];

      postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
        # The build erraneously marks the *.dylib as executable
        # which causes the qt-hook to wrap it, which then prevents the app from loading it
        chmod -x $out/lib/mumble/plugins/*.dylib

        # Post-processing for the app bundle
        $NIX_BUILD_TOP/source/macx/scripts/osxdist.py \
          --source-dir=$NIX_BUILD_TOP/source/ \
          --binary-dir=$out \
          --only-appbundle \
          --no-overlay \
          --version "${source.version}"

        mkdir -p $out/Applications $out/bin
        mv $out/Mumble.app $out/Applications/Mumble.app

        # ensure that the app can be started from the shell
        makeBinaryWrapper $out/Applications/Mumble.app/Contents/MacOS/mumble $out/bin/mumble
      '';

      postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgramBinary $out/bin/mumble \
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

      cmakeFlags = [
        "-D client=OFF"
        (lib.cmakeBool "ice" iceSupport)
        (lib.cmakeBool "enable-mysql" serverMysqlSupport)
        (lib.cmakeBool "enable-postgresql" serverPostgresqlSupport)
        (lib.cmakeBool "enable-sqlite" serverSqliteSupport)
      ]
      ++ lib.optionals iceSupport [
        "-D Ice_HOME=${lib.getDev zeroc-ice};${lib.getLib zeroc-ice}"
        "-D Ice_SLICE_DIR=${lib.getDev zeroc-ice}/share/ice/slice"
      ];

      buildInputs = [
        libcap
      ]
      ++ lib.optional iceSupport zeroc-ice
      ++ lib.optional serverPostgresqlSupport postgresql;
    } source;

  overlay =
    source:
    generic {
      stdenv = stdenv_32bit;
      type = "mumble-overlay";

      cmakeFlags = [
        "-D server=OFF"
        "-D client=OFF"
        "-D overlay=ON"
      ];
    } source;

  source = rec {
    version = "1.6.870";

    # Needs submodules
    src = fetchFromGitHub {
      owner = "mumble-voip";
      repo = "mumble";
      tag = "v${version}";
      hash = "sha256-FpZbFY/RvQOEDQAXkm1f5Oy00UUG11Az7LJnWfoinOM=";
      fetchSubmodules = true;
    };
  };
in
{
  mumble = lib.recursiveUpdate (client source) { meta.mainProgram = "mumble"; };
  murmur = lib.recursiveUpdate (server source) { meta.mainProgram = "mumble-server"; };
  overlay = overlay source;
}
