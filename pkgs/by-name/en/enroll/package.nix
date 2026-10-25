{
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "enroll";
  version = "1.2.9";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cosmic-utils";
    repo = "enroll";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zXHHgS7aApLLKkH9Ur77KBR/rjyOrTdLGwHK8ymj2V4=";
  };
  cargoHash = "sha256-A8tRiCxpOQRXPTC42IWsnS1pTrDlUFbTE4yG3iU+s+Q=";

  nativeBuildInputs = [ libcosmicAppHook ];

  # The justfile installs under a mismatched appid case; match the desktop file's Icon= instead.
  postInstall = ''
    install -Dm0644 resources/org.cosmic_utils.enroll.desktop -t $out/share/applications
    install -Dm0644 resources/org.cosmic_utils.enroll.metainfo.xml -t $out/share/metainfo
    install -Dm0644 resources/icons/hicolor/scalable/apps/enroll.svg \
      $out/share/icons/hicolor/scalable/apps/org.cosmic_utils.enroll.svg
  '';

  meta = {
    description = "Fingerprint enrollment for COSMIC";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ marcusramberg ];
    homepage = "https://github.com/cosmic-utils/enroll";
    changelog = "https://github.com/cosmic-utils/enroll/releases/tag/v${finalAttrs.version}";
    mainProgram = "cosmic-utils-enroll";
    platforms = lib.platforms.linux;
  };
})
