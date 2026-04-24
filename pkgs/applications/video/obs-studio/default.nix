{
  stdenv,
  stdenvNoCC,
  lib,
  fetchurl,
  fetchFromGitHub,
  fetchpatch2,
  qt6Packages,
  cmake,
  ninja,
  pkg-config,
  wrapQtAppsHook ? qt6Packages.wrapQtAppsHook,
  swig,
  simde,
  nix-update-script,
  curl,
  ffmpeg-full,
  jansson,
  qtbase ? qt6Packages.qtbase,
  qtsvg ? qt6Packages.qtsvg,
  speex,
  x264,
  mbedtls,
  cjson,
  libdatachannel,
  nlohmann_json,
  qrcodegencpp,
  websocketpp,
  asio,
  uthash,
  librist,
  libjack2,
  browserSupport ? true,
  scriptingSupport ? true,
}:

let
  pname = "obs-studio";
  version = "32.1.1";

  mkObsCefPackage =
    {
      platformMap,
      hashes,
      revision,
      version,
      buildType ? "Release",
    }:
    stdenvNoCC.mkDerivation {
      pname = "obs-studio-cef";
      version = "${version}-${revision}";

      src = fetchurl {
        url = "https://cdn-fastly.obsproject.com/downloads/cef_binary_${version}_${
          platformMap.${stdenv.hostPlatform.system}
            or (throw "Unsupported system ${stdenv.hostPlatform.system}")
        }_v${revision}.tar.xz";
        hash =
          hashes.${stdenv.hostPlatform.system} or (throw "Unsupported system ${stdenv.hostPlatform.system}");
      };

      dontBuild = true;
      sourceRoot = ".";

      installPhase = ''
        runHook preInstall
        mkdir -p "$out"
        cp -R . "$out"
        runHook postInstall
      '';

      passthru = {
        inherit buildType;
      };
    };

  meta = {
    description = "Free and open source software for video recording and live streaming";
    longDescription = ''
      This project is a rewrite of what was formerly known as "Open Broadcaster
      Software", software originally designed for recording and streaming live
      video content, efficiently
    '';
    homepage = "https://obsproject.com";
  };

  platformConfig =
    if stdenv.hostPlatform.isDarwin then
      qt6Packages.callPackage ./darwin.nix {
        inherit browserSupport scriptingSupport;
        inherit mkObsCefPackage;
      }
    else
      qt6Packages.callPackage ./linux.nix {
        inherit browserSupport scriptingSupport;
        inherit mkObsCefPackage;
      };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "obsproject";
    repo = "obs-studio";
    rev = finalAttrs.version;
    hash = "sha256-OiLlYnHaW+ehHtz4N20ctkfL4WmCzI45+VUG5hHOga4=";
    fetchSubmodules = true;
  };

  separateDebugInfo = platformConfig.separateDebugInfo or false;

  patches = [
    # Fix build with Qt 6.10 https://github.com/obsproject/obs-studio/pull/12328
    (fetchpatch2 {
      url = "https://github.com/obsproject/obs-studio/commit/26dfacbd4f5217258a2f1c5472a544c65a182d10.patch?full_index=1";
      hash = "sha256-gEWDzZ+GPCR+rmytXcbiBcvzLg8VwZCveMKkvho3COI=";
    })
  ]
  ++ (platformConfig.patches or [ ]);

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ]
  ++ lib.optional scriptingSupport swig
  ++ (platformConfig.extraNativeBuildInputs or [ ]);

  buildInputs = [
    asio
    cjson
    curl
    ffmpeg-full
    jansson
    libdatachannel
    libjack2
    librist
    mbedtls
    nlohmann_json
    qrcodegencpp
    qtbase
    qtsvg
    speex
    uthash
    websocketpp
    x264
  ]
  ++ (platformConfig.extraBuildInputs or [ ]);

  propagatedBuildInputs = [ simde ] ++ (platformConfig.propagatedBuildInputs or [ ]);

  postUnpack =
    lib.optionalString (browserSupport && platformConfig ? cef) ''
      ln -s ${platformConfig.cef} cef
    ''
    + (platformConfig.postUnpack or "");

  postPatch = ''
    cp ${./CMakeUserPresets.json} ./CMakeUserPresets.json
  ''
  + (platformConfig.postPatch or "");

  cmakeFlags = [
    "--preset"
    platformConfig.preset
    "-DOBS_VERSION_OVERRIDE=${finalAttrs.version}"
    "-Wno-dev"
    "-DENABLE_WEBRTC=ON"
    (lib.cmakeBool "ENABLE_BROWSER" browserSupport)
    (lib.cmakeBool "ENABLE_SCRIPTING" scriptingSupport)
  ]
  ++ (platformConfig.cmakeFlags or [ ])
  ++ lib.optional (browserSupport && platformConfig ? cef) "-DCEF_ROOT_DIR=../../cef";

  env = (platformConfig.env or { }) // {
    NIX_CFLAGS_COMPILE = toString (
      [
        "-Wno-error=deprecated-declarations"
        "-Wno-error=sign-compare"
      ]
      ++ (platformConfig.nixCflagsCompile or [ ])
    );
  };

  dontWrapGApps = platformConfig.dontWrapGApps or false;
  dontWrapQtApps = platformConfig.dontWrapQtApps or false;

  preFixup = platformConfig.preFixup or null;
  postFixup = platformConfig.postFixup or null;
  buildPhase = platformConfig.buildPhase or null;
  installPhase = platformConfig.installPhase or null;

  passthru.updateScript = nix-update-script { };

  meta = {
    inherit (meta) description longDescription homepage;
    inherit (platformConfig.meta) maintainers license platforms;
    mainProgram = "obs";
  };
})
