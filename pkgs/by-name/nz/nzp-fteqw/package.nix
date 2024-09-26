{
  lib,
  stdenv,
  fetchFromGitHub,
  nzportable,
  pkg-config,
  gnumake42,
  makeWrapper,
  libpng,
  zlib,
  gnutls,
  libGL,
  xorg,
  alsa-lib,
  libjpeg,
  libogg,
  libvorbis,
  libopus,
  SDL2,
  speex,
  speexdsp,
  freetype,
  bullet,
  openexr,
  sqlite,
  addOpenGLRunpath,

  enableEGL ? true,
  libglvnd,

  enableVulkan ? true,
  vulkan-loader,

  # TODO: Currently broken
  # EGL: eglCreateWindowSurface failed: BAD_MATCH
  # Vulkan: Error: vkCreateSwapchainKHR(4294967295 * 4294967295) failed with error VK_ERROR_OUT_OF_HOST_MEMORY
  enableWayland ? false,
  wayland,
  libxkbcommon,
}:
let
  platforms = {
    i686-linux = {
      target = "linux32";
      suffix = "32";
    };
    x86_64-linux = {
      target = "linux64";
      suffix = "64";
    };
    armv7l-linux = {
      target = "linux_armhf";
      suffix = "armhf";
    };
    aarch64-linux = {
      target = "linux_arm64";
      suffix = "arm64";
    };
  };

  platform =
    platforms.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "nzp-fteqw";
  version = "0-unstable-2023-12-01-03-29-00";

  src = fetchFromGitHub {
    owner = "nzp-team";
    repo = "fteqw";
    rev = "27eff6ffb0a2706cafb0d7b9570ca79b24ea7b83";
    hash = "sha256-npHCNvREnm57oimeztJBanw3L34xfe15/t9HnVaMYwA=";
  };

  sourceRoot = "${finalAttrs.src.name}/engine";

  outputs = [
    "out"
    "fteqcc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    # Newer versions of make produce a "warning: pattern recipe did not update peer target" spam.
    gnumake42
    makeWrapper
  ];

  buildInputs =
    [
      libGL
      xorg.libX11
      xorg.libXrandr
      xorg.libXcursor
      libjpeg
      libpng
      alsa-lib
      libogg
      libvorbis
      libopus
      SDL2
      gnutls
      zlib
      speex
      speexdsp
      freetype
      bullet
    ]
    ++ lib.optional enableEGL libglvnd
    ++ lib.optionals enableWayland [
      wayland
      libxkbcommon
    ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${libopus.dev}/include/opus" ];

  postPatch = ''
    ${lib.optionalString enableWayland ''
      substituteInPlace Makefile --replace-fail "/usr/include/wayland-client.h" "${wayland.dev}/include/wayland-client.h"
    ''}
    ${lib.optionalString enableEGL ''
      substituteInPlace Makefile --replace-fail "/usr/include/EGL/egl.h" "${libglvnd.dev}/include/EGL/egl.h"
    ''}
  '';

  buildFlags = [
    # m-rel = Merged (OpenGL + Direct3D + Dedicated Server), release build
    # See https://fte.triptohell.info/wiki/index.php/Compiling_FTEQW_For_Dummies#Understanding_Each_Build
    "m-rel"
    "FTE_TARGET=${platform.target}"
    "FTE_CONFIG=nzportable"
  ] ++ lib.optional (!enableVulkan) "VKCFLAGS=";

  enableParallelBuilding = true;

  postBuild = ''
    # FTEQCC
    make qcc -C qclib -j$NIX_BUILD_CORES
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 release/nzportable${platform.suffix} $out/bin/nzp-fteqw
    install -Dm755 qclib/fteqcc.bin $fteqcc/bin/fteqcc

    runHook postInstall
  '';

  postFixup =
    let
      # grep for `Sys_LoadLibrary` for more.
      # Some of the deps listed in the source code are actually not active
      # due to being disabled by the nzportable profile (e.g. lua, bz2),
      # available in /run/opengl-driver,
      # or statically linked (e.g. speex, libpng, libjpeg, zlib, freetype)
      # Some of them are also just deprecated by better backend options
      # (SDL audio is preferred over ALSA, OpenAL and PulseAudio, for example)

      libs = [
        addOpenGLRunpath.driverLink

        # gl/gl_vidlinuxglx.c
        xorg.libX11
        xorg.libXrandr
        xorg.libXxf86vm
        xorg.libXxf86dga
        xorg.libXi
        xorg.libXcursor
        libGL

        sqlite # server/sv_sql.c

        SDL2 # a lot of different files
        gnutls # common/net_ssl_gnutls.c
        openexr # client/image.c
      ] ++ lib.optional enableWayland wayland ++ lib.optional enableVulkan vulkan-loader;
    in
    ''
      wrapProgram $out/bin/nzp-fteqw \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath libs}"
    '';

  passthru.updateScript = nzportable.nzp-update {
    inherit (finalAttrs.src) owner repo;
    tag = "bleeding-edge";
  };

  meta = {
    description = "Nazi Zombies: Portable's fork of Spike's FTEQW engine/client";
    longDescription = ''
      This package contains only the FTEQW engine, and none of the assets used in NZ:P.
      Please use the `nzportable` package for an out-of-the-box NZ:P experience.

      FTEQW supports several graphics options.
      You can specify those graphics option by overriding the FTEQW package, like this:
      ```nix
        nzp-fteqw.override {
          enableVulkan = true;
        }
      ```
      And in the game, you need to run `setrenderer <renderer>` to change the current renderer.

      Supported graphics options are as follows:
      - `enableEGL`: Enable the OpenGL ES renderer (`egl`). Enabled by default.
      - `enableVulkan`: Enable the Vulkan renderer (`xvk`). Enabled by default.
      - `enableWayland`: Enable native Wayland support, instead of using X11.
        Adds up to two renderers, based on whether EGL and Vulkan are installed: `wlgl` and `wlvk`.
        Seems to be currently broken and currently not enabled by default.
    '';
    homepage = "https://github.com/nzp-team/fteqw";
    license = lib.licenses.gpl2Plus;
    platforms = lib.attrNames platforms;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "nzp-fteqw";
  };
})
