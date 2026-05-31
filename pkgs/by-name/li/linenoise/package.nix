{
  lib,
  stdenv,
  fetchFromGitHub,
  validatePkgConfig,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "linenoise";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "antirez";
    repo = "linenoise";
    tag = finalAttrs.version;
    hash = "sha256-lqJ/ecw7Q4QyDVXVFrxHL5EbNZOHpy5WruQn4VNibNA=";
  };

  nativeBuildInputs = [
    validatePkgConfig
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ];

  buildPhase = ''
    runHook preBuild

    $CC -c -o linenoise.o linenoise.c
    $CC -shared -o liblinenoise.so linenoise.o
    $AR rcs liblinenoise.a linenoise.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/pkgconfig $out/include
    install -m644 linenoise.h     $out/include/
    install -m644 liblinenoise.a  $out/lib/
    install -m644 liblinenoise.so $out/lib/
    substituteAll ${./linenoise.pc.in} $out/lib/pkgconfig/linenoise.pc

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/antirez/linenoise";
    description = "Minimal, zero-config, BSD licensed, readline replacement";
    maintainers = with lib.maintainers; [
      fstamour
      remexre
    ];
    platforms = lib.platforms.unix;
    license = lib.licenses.bsd2;
  };
})
