{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "nym-wg-go";
  version = "1.29.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "nymtech";
    repo = "nym-vpn-client";
    tag = "nym-vpn-core-v${version}";
    hash = "sha256-ZBcFC4ng/0NJvI6C/fbc7Oo2lOeiFFLpzrIUV1UNz+4=";
  };

  sourceRoot = "${src.name}/wireguard/libwg";

  vendorHash = "sha256-Ql9GuKInJYnijINlbYTB1H4GVJcO9lkVnclQzzNtCqQ=";

  buildPhase = ''
    runHook preBuild
    go build \
      -ldflags="-buildid=" \
      -trimpath \
      -buildvcs=false \
      -v \
      -o libwg.a \
      -buildmode c-archive \
      .
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 libwg.a $out/lib/libwg.a
    install -Dm644 libwg.h $out/include/libwg.h
    runHook postInstall
  '';

  doCheck = false;

  meta = {
    description = "Go-based WireGuard userspace library for NymVPN clients";
    longDescription = ''
      libwg is a CGo wrapper around the AmneziaWG fork of wireguard-go,
      built as a C static archive. It exposes a small C API consumed by
      the Rust nym-wg-go crate, which in turn is used by nym-vpnd to
      provide WireGuard userspace tunneling without a kernel module.
    '';
    homepage = "https://github.com/nymtech/nym-vpn-client";
    changelog = "https://github.com/nymtech/nym-vpn-client/releases/tag/nym-vpn-core-v${version}";
    license = with lib.licenses; [
      gpl3Only
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ rachyandco ];
    platforms = lib.platforms.linux;
  };
}
