{
  lib,
  stdenv,
  fetchFromGitHub,
  validatePkgConfig,
}:

let
  inherit (stdenv.hostPlatform) isStatic isDarwin extensions;
  libName = "liblinenoise${if isStatic then ".a" else extensions.sharedLibrary}";
in
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
  ];

  buildPhase = ''
    runHook preBuild

    $CC -c -o linenoise.o linenoise.c
    ${
      if isStatic then
        "$AR rcs"
      else
        "$CC ${
          if isDarwin then "-dynamiclib -install_name $out/lib/" else "-shared -Wl,-soname,"
        }${libName} -o"
    } ${libName} linenoise.o

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -d $out/lib/pkgconfig
    install -Dm644 linenoise.h -t $out/include
    install -Dm${if isStatic then "644" else "755"} ${libName} -t $out/lib
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
