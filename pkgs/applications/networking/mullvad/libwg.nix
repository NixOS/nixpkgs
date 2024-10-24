{ lib
, buildGoModule
, mullvad
}:
buildGoModule {
  pname = "libwg";

  inherit (mullvad)
    version
    src
    ;

  modRoot = "wireguard-go-rs/libwg";
  proxyVendor = true;
  vendorHash = "sha256-uyAzY1hoCtS7da3wtjxTGx5wBb9c9m749TzihVr94rc=";

  subPackages = [ "." ];
  ldflags = [ "-s" "-w" "-buildmode=c-archive" "-o" "${placeholder "out"}/lib" ];
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
