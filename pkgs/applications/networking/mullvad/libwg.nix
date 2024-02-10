{ lib
, buildGoModule
, mullvad
, fetchpatch
}:
buildGoModule {
  pname = "libwg";

  inherit (mullvad)
    version
    src
    ;

  sourceRoot = "${mullvad.src.name}/wireguard/libwg";

  vendorHash = "sha256-MQ5tVbcwMee6lmPyKSsNBh9jrz4zwx7INf1Cb0GxjHo=";

  # XXX: hack to make the ar archive go to the correct place
  # This is necessary because passing `-o ...` to `ldflags` does not work
  # (this doesn't get communicated everywhere in the chain, apparently, so
  # `go` complains that it can't find an `a.out` file).
  GOBIN = "${placeholder "out"}/lib";
  ldflags = [ "-s" "-w" "-buildmode=c-archive" ];

  patches = [
   # build broken without wintun reference
   # https://github.com/mullvad/mullvadvpn-app/pull/5621
   (fetchpatch {
     url = "https://github.com/mullvad/mullvadvpn-app/commit/5dff68ac9c8ec26f1a39a7f44e3b684bb0833bf1.patch";
     hash = "sha256-bUcDVmrrDblK7OJvHqf627vzVwmmvO2EL+sioAnZGbk=";
     relative = "wireguard/libwg";
   })
 ];

  postInstall = ''
    mv $out/lib/libwg{,.a}
  '';

  meta = with lib; {
    description = "A tiny wrapper around wireguard-go";
    homepage = "https://github.com/mullvad/mullvadvpn-app/tree/main/wireguard/libwg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cole-h ];
  };
}
