{
  fetchFromGitHub,
  rustPlatform,
  lib,
  nix-update-script,
  nixosTests,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "scx-loader";
  version = "1.1.1";

  cargoHash = "sha256-uX2lCVDa8eAKWi/bj94+JQHoOLll0OjKRHT0EPZELNc=";

  src = fetchFromGitHub {
    owner = "sched-ext";
    repo = "scx-loader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5OvdtW/Li+ubHDBSKe2ssE9ZyNSCcxNFSJffzxQ9WMk=";
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
