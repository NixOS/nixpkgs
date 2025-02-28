{
  lib,
  buildGoModule,
  mullvad,
}:
buildGoModule {
  pname = "libwg";

  inherit (mullvad)
    version
    src
    ;

  modRoot = "wireguard-go-rs/libwg";
  proxyVendor = true;
  vendorHash = "sha256-uzPtA9RBP5m8+18YBq+SEsgytDOWFCGPzucCzISSiLQ=";

  # XXX: hack to make the ar archive go to the correct place
  # This is necessary because passing `-o ...` to `ldflags` does not work
  # (this doesn't get communicated everywhere in the chain, apparently, so
  # `go` complains that it can't find an `a.out` file).
  GOBIN = "${placeholder "out"}/lib";

  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-buildmode=c-archive"
  ];
  tags = [ "daita" ];

  postInstall = ''
    mv $out/lib/libwg{,.a}
  '';

  meta = with lib; {
    description = "Tiny wrapper around wireguard-go";
    homepage = "https://github.com/mullvad/mullvadvpn-app/tree/main/wireguard-go-rs/libwg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cole-h ];
  };
}
