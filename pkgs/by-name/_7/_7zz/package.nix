{
  stdenv,
  lib,
  fetchzip,

  # Only useful on Linux x86/x86_64, and brings in non‐free Open Watcom
  uasm,
  useUasm ? false,

  # RAR code is under non-free unRAR license
  # see the meta.license section below for more details
  enableUnfree ? false,

  # For tests
  testers,
}:

let
  makefile =
    {
      aarch64-darwin = "../../cmpl_mac_arm64.mak";
      x86_64-darwin = "../../cmpl_mac_x64.mak";
      aarch64-linux = "../../cmpl_gcc_arm64.mak";
      i686-linux = "../../cmpl_gcc_x86.mak";
      x86_64-linux = "../../cmpl_gcc_x64.mak";
    }
    .${stdenv.hostPlatform.system} or "../../cmpl_gcc.mak"; # generic build
in
stdenv.mkDerivation (finalAttrs: {
  pname = "7zz";
  version = "25.01";

  src = fetchzip {
    url = "https://7-zip.org/a/7z${lib.replaceStrings [ "." ] [ "" ] finalAttrs.version}-src.tar.xz";
    hash =
      {
        free = "sha256-A1BBdSGepobpguzokL1zpjce5EOl0zqABYciv9zCOac=";
        unfree = "sha256-Jkj6T4tMols33uyJSOCcVmxh5iBYYCO/rq9dF4NDMko=";
      }
      .${if enableUnfree then "unfree" else "free"};
    stripRoot = false;
    # remove the unRAR related code from the src drv
    # > the license requires that you agree to these use restrictions,
    # > or you must remove the software (source and binary) from your hard disks
    # https://fedoraproject.org/wiki/Licensing:Unrar
    postFetch = lib.optionalString (!enableUnfree) ''
      rm -r $out/CPP/7zip/Compress/Rar*
    '';
  };

  patches = [
    ./fix-cross-mingw-build.patch
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isMinGW ''
    substituteInPlace CPP/7zip/7zip_gcc.mak C/7zip_gcc_c.mak \
      --replace windres.exe ${stdenv.cc.targetPrefix}windres
  '';

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-Wno-deprecated-copy-dtor"
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      "-Wno-conversion"
      "-Wno-unused-macros"
    ]
    ++ lib.optionals stdenv.cc.isClang [
      "-Wno-declaration-after-statement"
      (lib.optionals (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "13") [
        "-Wno-reserved-identifier"
        "-Wno-unused-but-set-variable"
      ])
      (lib.optionals (lib.versionAtLeast (lib.getVersion stdenv.cc.cc) "16") [
        "-Wno-unsafe-buffer-usage"
        "-Wno-cast-function-type-strict"
      ])
      # These three probably started to appear with clang 20 or 21:
      "-Wno-c++-keyword"
      "-Wno-implicit-void-ptr-cast"
      "-Wno-nrvo"
    ]
  );

  inherit makefile;

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ]
  ++ lib.optionals useUasm [ "MY_ASM=uasm" ]
  ++ lib.optionals (!useUasm && stdenv.hostPlatform.isx86) [ "USE_ASM=" ]
  # it's the compression code with the restriction, see DOC/License.txt
  ++ lib.optionals (!enableUnfree) [ "DISABLE_RAR_COMPRESS=true" ]
  ++ lib.optionals (stdenv.hostPlatform.isMinGW) [
    "IS_MINGW=1"
    "MSYSTEM=1"
  ];

  nativeBuildInputs = lib.optionals useUasm [ uasm ];

  setupHook = ./setup-hook.sh;

  enableParallelBuilding = true;

  preBuild = "cd CPP/7zip/Bundles/Alone2";

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin b/*/7zz${stdenv.hostPlatform.extensions.executable}
    install -Dm444 -t $out/share/doc/7zz ../../../../DOC/*.txt

    runHook postInstall
  '';

  passthru = {
    updateScript = ./update.sh;
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "7zz --help";
    };
  };

  meta = {
    description = "Command line archiver utility";
    homepage = "https://7-zip.org";
    license =
      with lib.licenses;
      # 7zip code is largely lgpl2Plus
      # CPP/7zip/Compress/LzfseDecoder.cpp is bsd3
      [
        lgpl2Plus # and
        bsd3
      ]
      ++
        # and CPP/7zip/Compress/Rar* are unfree with the unRAR license restriction
        # the unRAR compression code is disabled by default
        lib.optionals enableUnfree [ unfree ];
    maintainers = with lib.maintainers; [
      anna328p
      jk
      peterhoeg
    ];
    platforms = with lib.platforms; unix ++ windows;
    mainProgram = "7zz";
  };
})
