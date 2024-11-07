{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gnum4,
  pkg-config,
  python3,
  wayland-scanner,
  intel-gpu-tools,
  libdrm,
  libva,
  libX11,
  libGL,
  wayland,
  libXext,
  enableHybridCodec ? false,
  vaapi-intel-hybrid,
  enableGui ? true,
  nix-update-script,
}:

stdenv.mkDerivation {
  pname = "intel-vaapi-driver";
  version = "2.4.1-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "intel-vaapi-driver";
    rev = "fd727a4e9cb8b2878a1e93d4dddc8dd1c1a4e0ea";
    hash = "sha256-OMFdRjzpUKdxB9eK/1OLYLaOC3NHnzZVxmh6yKrbYoE=";
  };

  # Set the correct install path:
  LIBVA_DRIVERS_PATH = "${placeholder "out"}/lib/dri";

  postInstall = lib.optionalString enableHybridCodec ''
    ln -s ${vaapi-intel-hybrid}/lib/dri/* $out/lib/dri/
  '';

  configureFlags = [
    (lib.enableFeature enableGui "x11")
    (lib.enableFeature enableGui "wayland")
  ] ++ lib.optional enableHybridCodec "--enable-hybrid-codec";

  nativeBuildInputs = [
    autoreconfHook
    gnum4
    pkg-config
    python3
    wayland-scanner
  ];

  buildInputs =
    [
      intel-gpu-tools
      libdrm
      libva
    ]
    ++ lib.optionals enableGui [
      libX11
      libXext
      libGL
      wayland
    ]
    ++ lib.optional enableHybridCodec vaapi-intel-hybrid;

  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = with lib; {
    homepage = "https://01.org/linuxmedia";
    license = licenses.mit;
    description = "VA-API user mode driver for Intel GEN Graphics family";
    longDescription = ''
      This VA-API video driver backend provides a bridge to the GEN GPUs through
      the packaging of buffers and commands to be sent to the i915 driver for
      exercising both hardware and shader functionality for video decode,
      encode, and processing.
      VA-API is an open-source library and API specification, which provides
      access to graphics hardware acceleration capabilities for video
      processing. It consists of a main library and driver-specific acceleration
      backends for each supported hardware vendor.
    '';
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
