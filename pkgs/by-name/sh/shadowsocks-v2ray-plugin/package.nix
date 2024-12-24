{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "shadowsocks-v2ray-plugin";
  version = "1.3.1";
  # Version 1.3.2 has runtime failures with Go 1.19
  # https://github.com/NixOS/nixpkgs/issues/219343
  # https://github.com/shadowsocks/v2ray-plugin/issues/292
  # nixpkgs-update: no auto update

  src = fetchFromGitHub {
    owner = "shadowsocks";
    repo = "v2ray-plugin";
    rev = "v${version}";
    hash = "sha256-iwfjINY/NQP9poAcCHz0ETxu0Nz58AmD7i1NbF8hBCs=";
  };

  vendorHash = "sha256-3/1te41U4QQTMeoA1y43QMfJyiM5JhaLE0ORO8ZO7W8=";

  meta = with lib; {
    description = "Yet another SIP003 plugin for shadowsocks, based on v2ray";
    homepage = "https://github.com/shadowsocks/v2ray-plugin/";
    license = licenses.mit;
    maintainers = [ maintainers.ahrzb ];
    mainProgram = "v2ray-plugin";
  };
}
