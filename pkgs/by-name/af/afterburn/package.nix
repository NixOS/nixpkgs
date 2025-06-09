{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.8.2";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-hlcUtEc0uWFolCt+mZd7f68PJPa+i/mv+2aJh4Vhmsw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Wn4Np1rwHh2sL1sqKalJrIDgMffxJgD1C2QOAR8bDRo=";

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
