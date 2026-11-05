{
  lib,
  stdenv,
  cctools,
  darwin,
  fetchurl,
  autoconf,
  autogen,
  automake,
  gettext,
  libtool,
  lowdown-unsandboxed,
  protobuf,
  unzip,
  which,
  gmp,
  libsodium,
  python3,
  sqlite,
  zlib,
  jq,
  libpq,
}:
let
  py3 = python3.withPackages (p: [
    p.distutils
    p.mako
  ]);
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clightning";
  version = "26.06.10";

  src = fetchurl {
    url = "https://github.com/ElementsProject/lightning/releases/download/v${finalAttrs.version}/clightning-v${finalAttrs.version}.zip";
    hash = "sha256-SRRWHm0QjazKAYPX5rOxwiTFgFl93Ls5cpnvWw/MMjA=";
  };

  # Release archives can contain future-dated files (v26.06.10 used
  # 2026-11-05 00:00 for every file). Until that time, a future-dated Makefile
  # causes make to loop on ./configure --reconfigure without compiling.
  # Normalize mtimes to avoid this in future releases and backports;
  # a build after the archive's timestamp would hide the issue.
  postUnpack = ''
    find "$sourceRoot" -exec touch -h -d @1 {} +
  '';

  # when building on darwin we need cctools to provide the correct libtool
  # as libwally-core detects the host as darwin and tries to add the -static
  # option to libtool, also we have to add the modified gsed package.
  nativeBuildInputs = [
    autoconf
    autogen
    automake
    gettext
    libtool
    lowdown-unsandboxed
    protobuf
    py3
    unzip
    which
    libpq.pg_config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools
    darwin.autoSignDarwinBinariesHook
  ];

  buildInputs = [
    gmp
    libsodium
    sqlite
    zlib
    jq
  ];

  # this causes some python trouble on a darwin host so we skip this step.
  # also we have to tell libwally-core to use sed instead of gsed.
  postPatch =
    # chmod for `blockreplace.py` seems needed for all platforms
    ''
      chmod +x devtools/blockreplace.py
    ''
    + (
      if !stdenv.hostPlatform.isDarwin then
        ''
          patchShebangs \
            tools/generate-wire.py \
            tools/update-mocks.sh \
            tools/mockup.sh \
            tools/fromschema.py \
            devtools/sql-rewrite.py \
            devtools/blockreplace.py
        ''
      else
        ''
          substituteInPlace external/libwally-core/tools/autogen.sh --replace-fail gsed sed && \
            substituteInPlace external/libwally-core/configure.ac --replace-fail gsed sed
        ''
    );

  configureFlags = [ "--disable-valgrind" ];

  makeFlags = [ "VERSION=v${finalAttrs.version}" ];

  enableParallelBuilding = true;

  # workaround for build issue, happens only x86_64-darwin, not aarch64-darwin
  # ccan/ccan/fdpass/fdpass.c:16:8: error: variable length array folded to constant array as an extension [-Werror,-Wgnu-folding-constant]
  #                 char buf[CMSG_SPACE(sizeof(fd))];
  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
  ) "-Wno-error=gnu-folding-constant";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Bitcoin Lightning Network implementation in C";
    longDescription = ''
      Core Lightning (CLN), previously c-lightning, is standard compliant
      implementation of the Lightning Network protocol. The Lightning Network
      is a scalability solution for Bitcoin, enabling secure and instant
      transfer of funds between any two parties for any amount.
    '';
    homepage = "https://github.com/ElementsProject/lightning";
    maintainers = with lib.maintainers; [
      jb55
      prusnak
    ];
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "lightningd";
  };
})
