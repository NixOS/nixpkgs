{
  autoPatchelfHook,
  makeWrapper,
  stdenv,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "encore";
  version = "1.39.3";

  src =
    let
      platform = stdenv.targetPlatform;

      goarch =
        {
          "aarch64" = "arm64";
          "x86_64" = "amd64";
        }
        .${platform.parsed.cpu.name} or (throw "Unsupported system: ${platform.parsed.cpu.name}");

      goos = platform.parsed.kernel.name;
    in
    builtins.fetchurl {
      url = "https://d2f391esomvqpi.cloudfront.net/encore-${finalAttrs.version}-${goos}_${goarch}.tar.gz";
      sha256 = "05abmp45rym9g7n1l1935bpzm8a6vjnv0kpv9aj3kidssll18s3x";
    };

  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  unpackPhase = ''
    runHook preUnpack

    tar -xvzf $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share}

    cp -r {encore-go,runtimes} $out/share
    cp -r bin/* $out/bin

    wrapProgram $out/bin/encore \
      --set ENCORE_RUNTIMES_PATH $out/share/runtimes \
      --set ENCORE_GOROOT $out/share/encore-go \
      --set GOROOT $out/share/encore-go

    wrapProgram $out/bin/tsparser-encore \
      --set ENCORE_JS_RUNTIME_PATH $out/share/runtimes/js

    runHook postInstall
  '';

  meta = with lib; {
    description = "Backend Development Platform to create event-driven and distributed systems";
    homepage = "https://encore.dev";
    license = licenses.mpl20;
    maintainers = with maintainers; [ luisnquin ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "encore";
  };
})
