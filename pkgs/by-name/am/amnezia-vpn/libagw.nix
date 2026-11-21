{
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "libagw";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "amnezia-vpn";
    repo = "libagw";
    tag = "v${version}";
    hash = "sha256-1Bst1PDwrfU6yIVe29P1lE2ZKjKdLZVVCxtG5cyFmpY=";
  };

  vendorHash = null;
  env.CGO_ENABLED = 1;

  buildPhase = ''
    runHook preBuild

    go build -buildmode=c-archive -trimpath -ldflags="-w -s" -o libagw.a ./archive

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 libagw.a $out/lib/libagw.a
    install -Dm444 cabi/agw.h cabi/agw_types.h -t $out/include/

    runHook postInstall
  '';
}
