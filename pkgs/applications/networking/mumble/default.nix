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
  microsoft-gsl,
  nlohmann_json,
  xar,
  makeWrapper,
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

        buildInputs =
          [
            boost
            poco
            protobuf
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [ avahi ]
          ++ (overrides.buildInputs or [ ]);

        cmakeFlags = [
          "-D g15=OFF"
          "-D CMAKE_CXX_STANDARD=17" # protobuf >22 requires C++ 17
          "-D CMAKE_UNITY_BUILD=ON" # Upstream uses this in their build pipeline to speed up builds
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
          platforms = platforms.linux ++ (overrides.platforms or [ ]);
        };
      }
    );

  client =
    source:
    generic {
      type = "mumble";

      platforms = lib.platforms.darwin;
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
        ++ lib.optional (!jackSupport && alsaSupport) alsa-lib
        ++ lib.optional jackSupport libjack2
        ++ lib.optional speechdSupport speechd-minimal
        ++ lib.optional pulseSupport libpulseaudio
        ++ lib.optional pipewireSupport pipewire
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          xar
          makeWrapper
        ];

      cmakeFlags = [
        "-D server=OFF"
        "-D overlay=OFF" # defaults to client, but we have a separate target for the overlay
        "-D bundle-qt-translations=OFF"
        "-D bundled-json=OFF"
        "-D bundled-gsl=OFF"
        # "-D bundled-renamenoise=OFF" # not packaged in nixpkgs yet
        "-D update=OFF"
        "-D oss=OFF"
        "-D warnings-as-errors=OFF" # conversion error workaround
        (lib.cmakeBool "speechd" speechdSupport)
        (lib.cmakeBool "pulseaudio" pulseSupport)
        (lib.cmakeBool "pipewire" pipewireSupport)
        (lib.cmakeBool "jackaudio" jackSupport)
        (lib.cmakeBool "alsa" (!jackSupport && alsaSupport))
      ];

      env.NIX_CFLAGS_COMPILE = lib.optionalString speechdSupport "-I${speechd-minimal}/include/speech-dispatcher";

      patches = [
        ./disable-overlay-build.patch
        ./fix-plugin-copy.patch
        # Can be removed before the next update of Mumble, as that fix was upstreamed
        # fix version display in MacOS Finder
        (fetchpatch {
          url = "https://github.com/mumble-voip/mumble/pull/6742.patch";
          sha256 = "sha256-qFhC2j/cOWzAhs+KTccDIdcgFqfr4y4VLjHiK458Ucs=";
        })
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
          --version "${source.version}"

        mkdir -p $out/Applications $out/bin
        mv $out/Mumble.app $out/Applications/Mumble.app

        # ensure that the app can be started from the shell
        makeWrapper $out/Applications/Mumble.app/Contents/MacOS/mumble $out/bin/mumble
      '';

      postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
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
          "-D client=OFF"
          (lib.cmakeBool "ice" iceSupport)
        ]
        ++ lib.optionals iceSupport [
          "-D Ice_HOME=${lib.getDev zeroc-ice}"
          "-D Ice_SLICE_DIR=${lib.getDev zeroc-ice}/share/ice/slice"
        ];

      buildInputs = [ libcap ] ++ lib.optional iceSupport zeroc-ice;
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
  overlay = overlay source;
}
