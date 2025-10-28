{
  lib,
  openssl,
  pkg-config,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "afterburn";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "coreos";
    repo = "afterburn";
    tag = "v${version}";
    sha256 = "sha256-APVbrR4V2Go7ba+1AFZKi0eBxRnT2bm+Fy2/KmvhsjE=";
  };

  cargoHash = "sha256-WHfC9RPW/FXXZTfU2LEdkKvkJBt/9TemNpBOyv5/Wfo=";

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
