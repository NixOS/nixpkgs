{ lib
, stdenv
, buildGoPackage
, fetchFromGitHub
}:
buildGoPackage rec {
  pname = "snicat";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "CTFd";
    repo = "snicat";
    rev = version;
    hash = "sha256-fFlTBOz127le2Y7F9KKhbcldcyFEpAU5QiJ4VCAPs9Y=";
  };

  patchPhase = ''
    runHook prePatch

    substituteInPlace snicat.go \
      --replace-warn "v0.0.0" "v${version}"

    runHook postPatch
  '';

  goPackagePath = "github.com/CTFd/snicat";

  goDeps = ./deps.nix;

  installPhase = ''
    runHook preInstall

    install -Dm555 go/bin/snicat $out/bin/sc

    runHook postInstall
  '';

  meta = with lib; {
    description = "TLS & SNI aware netcat";
    homepage = "https://github.com/CTFd/snicat";
    license = licenses.asl20;
    mainProgram = "sc";
    maintainers = with maintainers; [ felixalbrigtsen ];
  };
}
