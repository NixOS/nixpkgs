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

  sourceRoot = "${mullvad.src.name}/wireguard/libwg";

  vendorHash = "sha256-2hb6+OHifm/oAgXCiYf+nwtNDDZNWR6lAbLSGT3AG0I=";

  # XXX: hack to make the ar archive go to the correct place
  # This is necessary because passing `-o ...` to `ldflags` does not work
  # (this doesn't get communicated everywhere in the chain, apparently, so
  # `go` complains that it can't find an `a.out` file).
  GOBIN = "${placeholder "out"}/lib";
  ldflags = [ "-s" "-w" "-buildmode=c-archive" ];

  patches = [
 ];

  postInstall = ''
    mv $out/lib/libwg{,.a}
  '';

  meta = with lib; {
    description = "Tiny wrapper around wireguard-go";
    homepage = "https://github.com/mullvad/mullvadvpn-app/tree/main/wireguard/libwg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cole-h ];
  };
}
