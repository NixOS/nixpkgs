{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  versionCheckHook,
  dbus,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  vulkan-loader,
  wayland,
  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mailcraft";
  version = "0.12.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "UCS-Care-Group";
    repo = "mailcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iaG5B8NiTFTHt4OGOKNugweC55ctQoGFHukGmuVZkJ8=";
  };

  cargoHash = "sha256-dUtr1uZJsXIlc2dnh6ZLHgku2w3v7IelAshP94uUsVs=";

  cargoBuildFlags = [
    "--package=mailcraft"
    "--package=mailcraft-cli"
  ];

  cargoTestFlags = [
    "--package=mailcraft-cli"
  ];

  nativeBuildInputs = [ pkg-config ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm644 packaging/linux/io.github.billsecond.mailcraft.desktop \
      $out/share/applications/io.github.billsecond.mailcraft.desktop
    install -Dm644 packaging/linux/io.github.billsecond.mailcraft.mime.xml \
      $out/share/mime/packages/io.github.billsecond.mailcraft.xml
    mkdir -p $out/share/icons
    cp -R assets/app-icon/hicolor $out/share/icons/
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/mailcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  __darwinAllowLocalNetworking = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mail, calendar and contacts client for Microsoft 365, Outlook.com and IMAP";
    homepage = "https://github.com/UCS-Care-Group/mailcraft";
    changelog = "https://github.com/UCS-Care-Group/mailcraft/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; mit;
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "mailcraft";
  };
})
