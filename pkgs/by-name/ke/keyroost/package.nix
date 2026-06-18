{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  pkg-config,
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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "framefilter";
    repo = "keyroost";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bAo9KMtKBDcIh8ZvDluNSn1tlOAZt9iYmp9d5Rmomec=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-9oX7zsf++6y6iQTDfoV8TOy7RNH4hcIFWMXEVB1fAJM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ pcsclite ];

  # winit/glutin dlopen Wayland, X11, libxkbcommon, and OpenGL at runtime
  postFixup = ''
    patchelf --add-rpath "${
      lib.makeLibraryPath [
        wayland
        libxkbcommon
        libGL
        libx11
        libxcursor
        libxi
        libxrandr
      ]
    }" $out/bin/keyroost
  '';

  postInstall = ''
    install -Dm444 -t $out/lib/udev/rules.d udev/*
    install -Dm444 -t $out/share/applications packaging/flatpak/io.github.framefilter.keyroost.desktop
    install -Dm444 -t $out/share/metainfo packaging/flatpak/io.github.framefilter.keyroost.metainfo.xml
    mkdir -p $out/share/icons
    cp -r packaging/icons/hicolor $out/share/icons/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/keyroostctl";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

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
