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
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "nowrep";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-sDgYHa6zwUsGAinWptFeeaTG5n9t7SCLYgjDurdMT6g=";
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
