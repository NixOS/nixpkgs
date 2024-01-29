{ lib
, bc
, fetchFromGitHub
, gmp
, libedit
, readline
, stdenv
, which
, xcbuild
, avx2Support ? stdenv.hostPlatform.avx2Support
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "j";
  version = "9.5.1";

  src = fetchFromGitHub {
    owner = "jsoftware";
    repo = "jsource";
    rev = "${finalAttrs.version}";
    hash = "sha256-QRQhE8138+zaGQOdq9xUOrifkVIprzbJWbmMK+WhEOU=";
  };

  patches = [
    ./0000-fix-install-path.patch
  ];

  nativeBuildInputs = [
    which
  ]
  ++ lib.optionals stdenv.isDarwin [
    xcbuild.xcrun
  ];

  buildInputs = [
    bc
    gmp
    libedit
    readline
  ];

  enableParallelBuilding = true;

  dontConfigure = true;

  env.NIX_LDFLAGS = "-lgmp";

  # Emulate jplatform64.sh
  buildPhase = let
    jplatform =
      if stdenv.isDarwin then "darwin"
      else if stdenv.hostPlatform.isAarch then "raspberry"
      else if stdenv.isLinux then "linux"
      else "unsupported";

    j64x =
      if stdenv.is32bit then "j32"
      else if stdenv.isx86_64 then
        if stdenv.isLinux && avx2Support then "j64avx2" else "j64"
      else if stdenv.isAarch64 then
        if stdenv.isDarwin then "j64arm" else "j64"
      else "unsupported";
  in ''
    runHook preBuild
    MAKEFLAGS+=" ''${enableParallelBuilding:+-j$NIX_BUILD_CORES}" \
      CC=${stdenv.cc.targetPrefix}cc jplatform=${jplatform} j64x=${j64x} make2/build_all.sh
    cp -v bin/${jplatform}/${j64x}/* jlibrary/bin/
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/j
    cp -r jlibrary/{addons,system} $out/share/j/
    cp -r jlibrary/bin $out/
    runHook postInstall
  '';

  meta = {
    homepage = "https://jsoftware.com/";
    description = "J programming language, an ASCII-based APL successor";
    longDescription = ''
      J is a high-level, general-purpose programming language that is
      particularly suited to the mathematical, statistical, and logical analysis
      of data. It is a powerful tool for developing algorithms and exploring
      problems that are not already well understood.
    '';
    license = with lib.licenses; [ gpl3Only ];
    mainProgram = "jconsole";
    maintainers = with lib.maintainers; [ raskin synthetica AndersonTorres ];
    platforms = lib.platforms.unix;
  };
})
