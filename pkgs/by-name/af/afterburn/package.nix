{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.8.1";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    rev = "v${version}";
    sha256 = "sha256-yW72gpABQBkWH9V/ZPccyCdZJV2Ojhhm5VebIzu8vc8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cYXvZAeYxkUQ1B6Ey60ErMfWjcg2mnUWU2qPzscjEOo=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace \
      ./systemd/afterburn-checkin.service \
      ./systemd/afterburn-firstboot-checkin.service \
      ./systemd/afterburn-sshkeys@.service.in \
      ./systemd/afterburn.service \
      --replace-fail /usr/bin $out/bin
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
