{
  alsa-lib,
  autoPatchelfHook,
  buildPackages,
  dbus,
  dotnet-sdk_6,
  dotnet-sdk_8,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  installShellFiles,
  lib,
  libdecor,
  libGL,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libxkbcommon,
  libXrandr,
  libXrender,
  makeWrapper,
  pkg-config,
  scons,
  speechd-minimal,
  stdenv,
  testers,
  udev,
  vulkan-loader,
  wayland,
  wayland-scanner,
  withDbus ? true,
  withFontconfig ? true,
  withMono ? false,
  withPlatform ? "linuxbsd",
  withPrecision ? "single",
  withPulseaudio ? true,
  withSpeechd ? true,
  withTarget ? "editor",
  withTouch ? true,
  withUdev ? true,
  # Wayland in Godot requires X11 until upstream fix is merged
  # https://github.com/godotengine/godot/pull/73504
  withWayland ? true,
  withX11 ? true,
}:
assert lib.asserts.assertOneOf "withPrecision" withPrecision [
  "single"
  "double"
];
let
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (
    k: v: if builtins.isString v then "${k}=${v}" else "${k}=${builtins.toJSON v}"
  );

  suffix = if withMono then "-mono" else "";

  arch = stdenv.hostPlatform.linuxArch;

  attrs = finalAttrs: rec {
    pname = "godot4${suffix}";
    version = "4.3-stable";
    commitHash = "77dcf97d82cbfe4e4615475fa52ca03da645dbd8";

    src = fetchFromGitHub {
      owner = "godotengine";
      repo = "godot";
      rev = commitHash;
      hash = "sha256-v2lBD3GEL8CoIwBl3UoLam0dJxkLGX0oneH6DiWkEsM=";
    };

    outputs = [
      "out"
      "man"
    ];
    separateDebugInfo = true;

    # Set the build name which is part of the version. In official downloads, this
    # is set to 'official'. When not specified explicitly, it is set to
    # 'custom_build'. Other platforms packaging Godot (Gentoo, Arch, Flatpack
    # etc.) usually set this to their name as well.
    #
    # See also 'methods.py' in the Godot repo and 'build' in
    # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
    BUILD_NAME = "nixpkgs";

    # Required for the commit hash to be included in the version number.
    #
    # `methods.py` reads the commit hash from `.git/HEAD` and manually follows
    # refs. Since we just write the hash directly, there is no need to emulate any
    # other parts of the .git directory.
    #
    # See also 'hash' in
    # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
    preConfigure =
      ''
        mkdir -p .git
        echo ${commitHash} > .git/HEAD
      ''
      + lib.optionalString withMono ''
        # TODO: avoid pulling in dependencies of windows-only project
        dotnet sln modules/mono/editor/GodotTools/GodotTools.sln \
          remove modules/mono/editor/GodotTools/GodotTools.OpenVisualStudio/GodotTools.OpenVisualStudio.csproj

        dotnet restore modules/mono/glue/GodotSharp/GodotSharp.sln
        dotnet restore modules/mono/editor/GodotTools/GodotTools.sln
        dotnet restore modules/mono/editor/Godot.NET.Sdk/Godot.NET.Sdk.sln
      '';

    # From: https://github.com/godotengine/godot/blob/4.2.2-stable/SConstruct
    sconsFlags = mkSconsFlagsFromAttrSet {
      # Options from 'SConstruct'
      precision = withPrecision; # Floating-point precision level
      production = true; # Set defaults to build Godot for use in production
      platform = withPlatform;
      target = withTarget;
      debug_symbols = true;

      # Options from 'platform/linuxbsd/detect.py'
      dbus = withDbus; # Use D-Bus to handle screensaver and portal desktop settings
      fontconfig = withFontconfig; # Use fontconfig for system fonts support
      pulseaudio = withPulseaudio; # Use PulseAudio
      speechd = withSpeechd; # Use Speech Dispatcher for Text-to-Speech support
      touch = withTouch; # Enable touch events
      udev = withUdev; # Use udev for gamepad connection callbacks
      wayland = withWayland; # Compile with Wayland support
      x11 = withX11; # Compile with X11 support

      module_mono_enabled = withMono;

      linkflags = "-Wl,--build-id";
    };

    enableParallelBuilding = true;

    strictDeps = true;

    depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
      buildPackages.stdenv.cc
      pkg-config
    ];

    buildInputs = lib.optionals withMono dotnet-sdk_6.packages;

    nativeBuildInputs =
      [
        autoPatchelfHook
        installShellFiles
        pkg-config
        scons
      ]
      ++ lib.optionals withWayland [ wayland-scanner ]
      ++ lib.optionals withMono [
        dotnet-sdk_8
        makeWrapper
      ];

    postBuild = lib.optionalString withMono ''
      echo "Generating Glue"
      if [[ ${withPrecision} == *double* ]]; then
          bin/godot.${withPlatform}.${withTarget}.${withPrecision}.${arch}.mono --headless --generate-mono-glue modules/mono/glue
      else
          bin/godot.${withPlatform}.${withTarget}.${arch}.mono --headless --generate-mono-glue modules/mono/glue
      fi
      echo "Building C#/.NET Assemblies"
      python modules/mono/build_scripts/build_assemblies.py --godot-output-dir bin --precision=${withPrecision}
    '';

    runtimeDependencies =
      [
        alsa-lib
        libGL
        vulkan-loader
      ]
      ++ lib.optionals withX11 [
        libX11
        libXcursor
        libXext
        libXfixes
        libXi
        libXinerama
        libxkbcommon
        libXrandr
        libXrender
      ]
      ++ lib.optionals withWayland [
        libdecor
        wayland
      ]
      ++ lib.optionals withDbus [
        dbus
        dbus.lib
      ]
      ++ lib.optionals withFontconfig [
        fontconfig
        fontconfig.lib
      ]
      ++ lib.optionals withPulseaudio [ libpulseaudio ]
      ++ lib.optionals withSpeechd [ speechd-minimal ]
      ++ lib.optionals withUdev [ udev ];

    installPhase =
      ''
        runHook preInstall

        mkdir -p "$out/bin"
        cp bin/godot.* $out/bin/godot4${suffix}

        installManPage misc/dist/linux/godot.6

        mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
        cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot4${suffix}.desktop"
        substituteInPlace "$out/share/applications/org.godotengine.Godot4${suffix}.desktop" \
          --replace "Exec=godot" "Exec=$out/bin/godot4${suffix}" \
          --replace "Godot Engine" "Godot Engine 4"
        cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
        cp icon.png "$out/share/icons/godot.png"
      ''
      + lib.optionalString withMono ''
        cp -r bin/GodotSharp/ $out/bin/
        wrapProgram $out/bin/godot4${suffix} \
          --set DOTNET_ROOT ${dotnet-sdk_8} \
          --prefix PATH : "${
            lib.makeBinPath [
              dotnet-sdk_8
            ]
          }"
      ''
      + ''
        runHook postInstall
      '';

    passthru.tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
        version = lib.replaceStrings [ "-" ] [ "." ] version;
      };
    };

    requiredSystemFeatures = [
      # fixes: No space left on device
      "big-parallel"
    ];

    meta = {
      changelog = "https://github.com/godotengine/godot/releases/tag/${version}";
      description = "Free and Open Source 2D and 3D game engine";
      homepage = "https://godotengine.org";
      license = lib.licenses.mit;
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
      ] ++ lib.optional (!withMono) "i686-linux";
      maintainers = with lib.maintainers; [
        shiryel
        corngood
      ];
      mainProgram = "godot4${suffix}";
    };
  };

in
stdenv.mkDerivation (
  if withMono then
    dotnetCorePackages.addNuGetDeps {
      nugetDeps = ./deps.json;
      overrideFetchAttrs = old: rec {
        runtimeIds = map (system: dotnetCorePackages.systemToDotnetRid system) old.meta.platforms;
        buildInputs =
          old.buildInputs
          ++ lib.concatLists (lib.attrValues (lib.getAttrs runtimeIds dotnet-sdk_6.targetPackages));
      };
    } attrs
  else
    attrs
)
