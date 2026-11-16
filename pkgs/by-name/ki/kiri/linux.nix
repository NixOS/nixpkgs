{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gnutar,
  version,
  meta,
  passthru,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kiri";
  __structuredAttrs = true;
  inherit version passthru;

  src = fetchFromGitHub {
    owner = "libracoder";
    repo = "kiri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XmY66vyM/jnI0tDhKEjx8yKFXLjf/q0WojtU4/fgwxk=";
  };

  cargoHash = "sha256-zYHkfntI7KAHUA3/11StA09IWJnsiA9axkwec51utss=";

  # Upstream stamps the version into Cargo.toml at release time; checkouts say 0.0.0.
  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${finalAttrs.version}"'
    substituteInPlace crates/kiri/src/scan.rs \
      --replace-fail '"/bin/tar"' '"${lib.getExe gnutar}"'
  '';

  cargoBuildFlags = [
    "--package=kiri"
    "--package=kiri-init"
  ];

  # The suite drives a real engine (namespaces, cgroups, a docker CLI).
  doCheck = false;

  postInstall = ''
    install -Dm644 packaging/linux/kiri.service $out/lib/systemd/system/kiri.service
    substituteInPlace $out/lib/systemd/system/kiri.service \
      --replace-fail /usr/bin/kiri $out/bin/kiri
    install -Dm644 packaging/linux/dev.kiri.host-access.policy \
      $out/share/polkit-1/actions/dev.kiri.host-access.policy
    substituteInPlace $out/share/polkit-1/actions/dev.kiri.host-access.policy \
      --replace-fail /usr/bin/kiri $out/bin/kiri
  '';

  meta = meta // {
    platforms = lib.platforms.linux;
  };
})
