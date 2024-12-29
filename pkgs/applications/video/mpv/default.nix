{
  lib,
  SDL2,
  addDriverRunpath,
  alsa-lib,
  bash,
  buildPackages,
  callPackage,
  config,
  docutils,
  fetchFromGitHub,
  ffmpeg,
  freefont_ttf,
  freetype,
  lcms2,
  libGL,
  libX11,
  libXScrnSaver,
  libXext,
  libXpresent,
  libXrandr,
  libarchive,
  libass,
  libbluray,
  libbs2b,
  libcaca,
  libcdio,
  libcdio-paranoia,
  libdrm,
  libdvdnav,
  libjack2,
  libplacebo,
  libpthreadstubs,
  libpulseaudio,
  libsixel,
  libuchardet,
  libva,
  libvdpau,
  libxkbcommon,
  lua,
  makeWrapper,
  libgbm,
  meson,
  mujs,
  ninja,
  nixosTests,
  nv-codec-headers-11,
  openalSoft,
  pipewire,
  pkg-config,
  python3,
  rubberband,
  shaderc, # instead of spirv-cross
  stdenv,
  swift,
  testers,
  vapoursynth,
  vulkan-headers,
  vulkan-loader,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zimg,

  # Boolean
  alsaSupport ? stdenv.hostPlatform.isLinux,
  archiveSupport ? true,
  bluraySupport ? true,
  bs2bSupport ? true,
  cacaSupport ? true,
  cddaSupport ? false,
  cmsSupport ? true,
  drmSupport ? stdenv.hostPlatform.isLinux,
  dvbinSupport ? stdenv.hostPlatform.isLinux,
  dvdnavSupport ? true,
  jackaudioSupport ? false,
  javascriptSupport ? true,
  openalSupport ? true,
  pipewireSupport ? !stdenv.hostPlatform.isDarwin,
  pulseSupport ? config.pulseaudio or (!stdenv.hostPlatform.isDarwin),
  rubberbandSupport ? true,
  sdl2Support ? false,
  sixelSupport ? false,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin && (x11Support || waylandSupport),
  vapoursynthSupport ? false,
  vdpauSupport ? true,
  vulkanSupport ? true,
  waylandSupport ? !stdenv.hostPlatform.isDarwin,
  x11Support ? !stdenv.hostPlatform.isDarwin,
  zimgSupport ? true,
}:

let
  luaEnv = lua.withPackages (ps: with ps; [ luasocket ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mpv";
  version = "0.39.0";

  outputs = [
    "out"
    "dev"
    "doc"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "mpv-player";
    repo = "mpv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BOGh+QBTO7hrHohh+RqjSF8eHQH8jVBPjG/k4eyFaaM=";
  };

  postPatch = lib.concatStringsSep "\n" [
    # Don't reference compile time dependencies or create a build outputs cycle
    # between out and dev
    ''
      substituteInPlace meson.build \
        --replace-fail "conf_data.set_quoted('CONFIGURATION', configuration)" \
                       "conf_data.set_quoted('CONFIGURATION', '<omitted>')"
    ''
    # A trick to patchShebang everything except mpv_identify.sh
    ''
      pushd TOOLS
      mv mpv_identify.sh mpv_identify
      patchShebangs *.py *.sh
      mv mpv_identify mpv_identify.sh
      popd
    ''
  ];

  # Ensure we reference 'lib' (not 'out') of Swift.
  # TODO: Remove this once the Swift wrapper doesn’t include these.
  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export SWIFT_LIB_DYNAMIC="${lib.getLib swift.swift}/lib/swift/macosx"
  '';

  mesonFlags = [
    (lib.mesonOption "default_library" "shared")
    (lib.mesonBool "libmpv" true)
    (lib.mesonEnable "manpage-build" true)
    (lib.mesonEnable "cdda" cddaSupport)
    (lib.mesonEnable "dvbin" dvbinSupport)
    (lib.mesonEnable "dvdnav" dvdnavSupport)
    (lib.mesonEnable "openal" openalSupport)
    (lib.mesonEnable "sdl2" sdl2Support)
  ];

  mesonAutoFeatures = "auto";

  nativeBuildInputs =
    [
      addDriverRunpath
      docutils # for rst2man
      meson
      ninja
      pkg-config
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      buildPackages.darwin.sigtool
      swift
      makeWrapper
    ]
    ++ lib.optionals waylandSupport [ wayland-scanner ];

  buildInputs =
    [
      bash
      ffmpeg
      freetype
      libass
      libplacebo
      libpthreadstubs
      libuchardet
      luaEnv
      python3
    ]
    ++ lib.optionals alsaSupport [ alsa-lib ]
    ++ lib.optionals archiveSupport [ libarchive ]
    ++ lib.optionals bluraySupport [ libbluray ]
    ++ lib.optionals bs2bSupport [ libbs2b ]
    ++ lib.optionals cacaSupport [ libcaca ]
    ++ lib.optionals cddaSupport [
      libcdio
      libcdio-paranoia
    ]
    ++ lib.optionals cmsSupport [ lcms2 ]
    ++ lib.optionals drmSupport [
      libdrm
      libgbm
    ]
    ++ lib.optionals dvdnavSupport [
      libdvdnav
      libdvdnav.libdvdread
    ]
    ++ lib.optionals jackaudioSupport [ libjack2 ]
    ++ lib.optionals javascriptSupport [ mujs ]
    ++ lib.optionals openalSupport [ openalSoft ]
    ++ lib.optionals pipewireSupport [ pipewire ]
    ++ lib.optionals pulseSupport [ libpulseaudio ]
    ++ lib.optionals rubberbandSupport [ rubberband ]
    ++ lib.optionals sdl2Support [ SDL2 ]
    ++ lib.optionals sixelSupport [ libsixel ]
    ++ lib.optionals vaapiSupport [ libva ]
    ++ lib.optionals vapoursynthSupport [ vapoursynth ]
    ++ lib.optionals vdpauSupport [ libvdpau ]
    ++ lib.optionals vulkanSupport [
      shaderc
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals waylandSupport [
      wayland
      wayland-protocols
      libxkbcommon
    ]
    ++ lib.optionals x11Support [
      libX11
      libXext
      libGL
      libXrandr
      libXpresent
      libXScrnSaver
    ]
    ++ lib.optionals zimgSupport [ zimg ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ nv-codec-headers-11 ];

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    pushd .. # Must be run from the source dir because it uses relative paths
    python3 TOOLS/osxbundle.py -s build/mpv
    popd
  '';

  postInstall =
    ''
      # Use a standard font
      mkdir -p $out/share/mpv
      ln -s ${freefont_ttf}/share/fonts/truetype/FreeSans.ttf $out/share/mpv/subfont.ttf

      pushd ../TOOLS
      cp mpv_identify.sh umpv $out/bin/
      popd
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      pushd $out/share/applications

      sed -e '/Icon=/ ! s|mpv|umpv|g; s|^Exec=.*|Exec=umpv %U|' \
        mpv.desktop > umpv.desktop
      printf "NoDisplay=true\n" >> umpv.desktop
      popd
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r mpv.app $out/Applications

      # On macOS, many things won’t work properly unless `mpv(1)` is
      # executed from the app bundle, such as spatial audio with
      # `--ao=avfoundation`. This wrapper ensures that those features
      # work reliably and also avoids shipping two copies of the entire
      # `mpv` executable.
      makeWrapper $out/Applications/mpv.app/Contents/MacOS/mpv $out/bin/mpv
    '';

  # Set RUNPATH so that libcuda in /run/opengl-driver(-32)/lib can be found.
  # See the explanation in addDriverRunpath.
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    addDriverRunpath $out/bin/mpv
    patchShebangs --update --host $out/bin/umpv $out/bin/mpv_identify.sh
  '';

  passthru = {
    inherit
      # The wrapper consults luaEnv and lua.version
      luaEnv
      lua
      # In the wrapper, we want to reference vapoursynth which has the `python3`
      # passthru attribute (which has the `sitePrefix` attribute). This way we'll
      # be sure that in the wrapper we'll use the same python3.sitePrefix used to
      # build vapoursynth.
      vapoursynthSupport
      vapoursynth
      ;

    wrapper = callPackage ./wrapper.nix { };
    scripts = callPackage ./scripts.nix { };

    tests = {
      inherit (nixosTests) mpv;

      version = testers.testVersion { package = finalAttrs.finalPackage; };
      pkg-config = testers.hasPkgConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "mpv" ];
      };
    };
  };

  meta = {
    homepage = "https://mpv.io";
    description = "General-purpose media player, fork of MPlayer and mplayer2";
    longDescription = ''
      mpv is a free and open-source general-purpose video player, based on the
      MPlayer and mplayer2 projects, with great improvements above both.
    '';
    changelog = "https://github.com/mpv-player/mpv/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    mainProgram = "mpv";
    maintainers = with lib.maintainers; [
      AndersonTorres
      fpletz
      globin
      ma27
    ];
    platforms = lib.platforms.unix;
  };
})
