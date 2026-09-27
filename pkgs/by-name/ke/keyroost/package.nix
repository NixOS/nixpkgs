{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  hidapi,
  pcsclite,
  libxkbcommon,
  libx11,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  libGL,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keyroost";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "framefilter";
    repo = "keyroost";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ArLDhyuK04eq/1RYsBHNm3U7AzaGsYZWhH+q0Q+9gIg=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-zktnXrLGj2WUQlTtqOsIXD0QhdPPVbnw37+zSuuj0qg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    hidapi
    pcsclite
    libxkbcommon
    libx11
    libxcursor
    libxi
    libxrandr
    wayland
    libGL
  ];

  # egui dynamically loads Wayland, libxkbcommon, and OpenGL at runtime
  postFixup = ''
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        libGL
      ]
    }" $out/bin/keyroost
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d udev/*
  '';

  meta = {
    description = "Hardware security key management supporting FIDO2, OATH, OpenPGP, and PIV over PC/SC and USB HID";
    homepage = "https://github.com/framefilter/keyroost";
    changelog = "https://github.com/framefilter/keyroost/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ io12 ];
    mainProgram = "keyroost";
    platforms = lib.platforms.linux;
  };
})
