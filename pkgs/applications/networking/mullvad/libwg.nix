{ lib
, buildGoModule
, fetchFromGitHub
, mullvad
}:
buildGoModule {
  pname = "libwg";

  inherit (mullvad)
    version
    src
    ;

  sourceRoot = "source/wireguard/libwg";

  vendorSha256 = "qvymWCdJ+GY90W/Fpdp+r1+mTq6O4LyN2Yw/PjKdFm0=";

  # XXX: hack to make the ar archive go to the correct place
  # This is necessary because passing `-o ...` to `ldflags` does not work
  # (this doesn't get communicated everywhere in the chain, apparently, so
  # `go` complains that it can't find an `a.out` file).
  GOBIN = "${placeholder "out"}/lib";
  ldflags = [ "-s" "-w" "-buildmode=c-archive" ];

  postInstall = ''
    mv $out/lib/libwg{,.a}
  '';

  meta = with lib; {
    description = "A tiny wrapper around wireguard-go";
    homepage = "https://github.com/mullvad/mullvadvpn-app/tree/master/wireguard/libwg";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ cole-h ];
  };
}
