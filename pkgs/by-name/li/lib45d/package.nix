{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  name = "lib45d";
  version = "0.3.6";
  src = fetchFromGitHub {
    owner = "45Drives";
    repo = "lib45d";
    tag = "v${finalAttrs.version}";
    hash = "sha256-42xB30Iu2WxNrBxomVBKd/uyIRt27y/Y1ah5mckOrc0=";
  };

  patches = [
    # https://github.com/45Drives/lib45d/issues/3
    # fix "error: 'uintmax_t' has not been declared" build failure until next release
    (fetchpatch {
      url = "https://github.com/45Drives/lib45d/commit/a607e278182a3184c004c45c215aa22c15d6941d.patch";
      hash = "sha256-sMAvOp4EjBXGHa9PGuuEqJvpEvUlMuzRKCfq9oqQLgY=";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/lib dist/shared/lib45d.so

    mkdir -p $out/include/45d
    cp -f -r src/incl/45d/* $out/include/45d/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/45Drives/lib45d";
    description = "45Drives C++ Library";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ philipwilk ];
    platforms = lib.platforms.linux;
  };
})
