{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "shadowsocks-qtun-plugin";
  version = "0.3.0-unstable-2026-02-07";

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "qtun";
    rev = "ab58110075488f8411b0eafd3d9412be2ace3c61";
    hash = "sha256-hA/XoSZcnci2PqfeyR0ELi4dty9jE3Lsq/lgOfZ0zQ0=";
  };

  cargoHash = "sha256-iIqN25t9GxQ4jC5NtpOuDztdS+mCnEh7oDJXm9PivOo=";

  meta = {
    description = "Yet another SIP003 plugin based on IETF-QUIC";
    homepage = "https://github.com/shadowsocks/qtun";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ neverbehave ];
    mainProgram = "qtun-server";
  };
}
