{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx-loader";
  version = "1.1.2";

  cargoHash = "sha256-jzp1Z64p35Ap6TYuN977up8Ls8Jakfz9CeM5+brgtuQ=";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SFolb2S7HGSsUPxXtiVCv/6N4XNqOU62c3GZX9axk9k=";
  };

  __structuredAttrs = true;

  env = {
    VENDOR_PREFIX = "";
    VENDOR_DATADIR = "/share";
  };

  postInstall = ''
    cargo xtask install --destdir $out
    rm $out/bin/xtask
  '';

  postFixup = ''
    substituteInPlace $out/lib/systemd/system/scx_loader.service \
      --replace-fail "/usr/bin/scx_loader" "$out/bin/scx_loader"
    substituteInPlace $out/share/dbus-1/system-services/org.scx.Loader.service \
      --replace-fail "/usr/bin/scx_loader" "$out/bin/scx_loader"
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests = { inherit (nixosTests) scx-loader; };
  };

  meta = {
    mainProgram = "scxctl";
    homepage = "https://github.com/sched-ext/scx-loader";
    changelog = "https://github.com/sched-ext/scx-loader/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      Gliczy
      michaelBelsanti
      ccicnce113424
    ];
  };
})
