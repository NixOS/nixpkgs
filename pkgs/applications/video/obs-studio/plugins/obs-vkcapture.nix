{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, ninja
, wayland
, wayland-scanner
, obs-studio
, libffi
, libX11
, libXau
, libXdmcp
, libxcb
, vulkan-headers
, vulkan-loader
, libGL
, obs-vkcapture32
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-vkcapture";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-hYPQ1N4k4eb+bvGWZqaQJ/C8C5Lh8ooZ03raGF5ORgE=";
  };

  cmakeFlags = lib.optionals stdenv.isi686 [
    # We don't want to build the plugin for 32bit. The library integrates with
    # the 64bit plugin but it's necessary to be loaded into 32bit games.
    "-DBUILD_PLUGIN=OFF"
  ];

  nativeBuildInputs = [ cmake extra-cmake-modules ninja wayland-scanner ];
  buildInputs = [
    libGL
    libffi
    libX11
    libXau
    libXdmcp
    libxcb
    vulkan-headers
    vulkan-loader
    wayland
  ]
  ++ lib.optionals (!stdenv.isi686) [
    obs-studio
  ];

  postPatch = ''
    substituteInPlace src/glinject.c \
      --replace "libGLX.so.0" "${lib.getLib libGL}/lib/libGLX.so.0" \
      --replace "libX11.so.6" "${lib.getLib libX11}/lib/libX11.so.6" \
      --replace "libX11-xcb.so.1" "${lib.getLib libX11}/lib/libX11-xcb.so.1" \
      --replace "libxcb-dri3.so.0" "${lib.getLib libxcb}/lib/libxcb-dri3.so.0" \
      --replace "libEGL.so.1" "${lib.getLib libGL}/lib/libEGL.so.1" \
      --replace "libvulkan.so.1" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
  '';

  # Support 32bit Vulkan applications by linking in the 32bit Vulkan layer
  postInstall = lib.optionalString (stdenv.hostPlatform.system == "x86_64-linux") ''
    ln -s ${obs-vkcapture32}/share/vulkan/implicit_layer.d/obs_vkcapture_32.json \
      "$out/share/vulkan/implicit_layer.d/"
  '';

  meta = with lib; {
    description = "OBS Linux Vulkan/OpenGL game capture";
    homepage = "https://github.com/nowrep/obs-vkcapture";
    changelog = "https://github.com/nowrep/obs-vkcapture/releases/tag/v${finalAttrs.version}";
    maintainers = with maintainers; [ atila pedrohlc ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
})
