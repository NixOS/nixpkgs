{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  onnxruntime,
  pipewire,
  libxkbcommon,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lumine-capture";
  version = "0.3.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Netflate";
    repo = "LumineCapture";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/xudAWQlgB0tnwSYM0ZCxQiYD+8vwdJ9GcPEk6EB5nk=";
  };

  cargoHash = "sha256-V9Zwaqewy21rnTJ4vqK+FjGANt68NtxJbjSRqVWA7TA=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    onnxruntime
    pipewire
    libxkbcommon
    openssl
  ];

  # link to onnxruntime from nixpkgs to prevent ort-sys from downloading a prebuilt one
  env = {
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "1";
  };

  postInstall = ''
    # ort's copy-dylibs creates a copy of onnxruntime next to the binary
    rm -r $out/lib

    # KWin only allows org.kde.KWin.ScreenShot2 for the executable named in Exec=
    # of a .desktop file with X-KDE-DBUS-Restricted-Interfaces, so it must be the store path
    install -Dm644 assets/lumine-capture.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/lumine-capture.desktop \
      --replace-fail /usr/bin/lumine-capture $out/bin/lumine-capture
    mkdir -p $out/share/icons
    cp -r assets/hicolor $out/share/icons/
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Screenshot and annotation tool for Wayland with built-in OCR";
    homepage = "https://github.com/Netflate/LumineCapture";
    changelog = "https://github.com/Netflate/LumineCapture/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
      ofl
    ];
    mainProgram = "lumine-capture";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ netflate ];
  };
})
