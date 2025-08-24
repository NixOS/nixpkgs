{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    tag = "v${version}";
    sha256 = "sha256-kMq3yoqIp2j5DRQFarEK9kss9DoVgAEkjUYJX5Ogu0g=";
  };

  cargoHash = "sha256-pWt2+SptdTiP4/oROw38qc6ekfbVWOf86BR18QC+ZPU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace \
      ./systemd/afterburn-checkin.service \
      ./systemd/afterburn-firstboot-checkin.service \
      ./systemd/afterburn-sshkeys@.service.in \
      ./systemd/afterburn.service \
      --replace-fail /usr/bin "$out/bin"
  '';

  postInstall = ''
    DEFAULT_INSTANCE=root PREFIX= DESTDIR=$out make install-units
  '';

  meta = {
    homepage = "https://github.com/coreos/afterburn";
    description = "One-shot cloud provider agent";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ arianvp ];
    platforms = lib.platforms.linux;
    mainProgram = "afterburn";
  };
}
