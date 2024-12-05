{ lib
, buildGoModule
, fetchgit
, makeWrapper
, mpv
}:
buildGoModule rec {
  pname = "ff2mpv-go";
  version = "1.0.1";

  src = fetchgit {
    url = "https://git.clsr.net/util/ff2mpv-go/";
    rev = "v${version}";
    hash = "sha256-e/AuOA3isFTyBf97Zwtr16yo49UdYzvktV5PKB/eH/s=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  vendorHash = null;

  postInstall = ''
    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    $out/bin/ff2mpv-go --manifest > "$out/lib/mozilla/native-messaging-hosts/ff2mpv.json"
  '';

  postFixup = ''
    wrapProgram $out/bin/ff2mpv-go --suffix PATH ":" ${lib.makeBinPath [ mpv ]}
  '';

  meta = with lib; {
    description = "Native messaging host for ff2mpv written in Go";
    homepage = "https://git.clsr.net/util/ff2mpv-go/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ ambroisie ];
    mainProgram = "ff2mpv-go";
  };
}
