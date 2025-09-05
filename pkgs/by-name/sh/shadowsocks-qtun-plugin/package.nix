{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "shadowsocks-qtun-plugin";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "qtun";
    tag = "v${version}";
    hash = "sha256-JYwbDlza/EuWeEiO8KS96y7koIbpOocBKS5VZjyzP6g=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = {
    description = "Yet another SIP003 plugin based on IETF-QUIC";
    homepage = "https://github.com/shadowsocks/qtun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ neverbehave ];
    mainProgram = "qtun-server";
  };
}
