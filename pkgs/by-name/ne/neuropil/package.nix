{
  lib,
  stdenv,
  fetchFromGitLab,
  nix-update-script,

  # build-time
  fixDarwinDylibNames,
  git,
  python3,
  scons,

  # run-time
  criterion,
  libsodium,
  msgpack-cmp,
  ncurses,
  parson,
  sqlite,
  qcbor,

  withDebug ? true,
  withSystemMsgpackCmp ? true,
  withSystemQcbor ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "neuropil";
  version = "1.0.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    owner = "pi-lar";
    repo = "neuropil";
    tag = "neuropil_${finalAttrs.version}";
    hash = "sha256-NQU3dL/4ftV730i9snW+K9wdnRsirYnOgHw6F5VuR7w=";
    fetchSubmodules = true;
  };

  patches = lib.optionals withSystemQcbor [
    ./0001-Remove-duplicate-QCBOR_Int64ToUInt16.patch
    ./0002-Disable-vendord-qcbor.patch
  ];

  postPatch = ''
    # Replace non-breaking spaces with standard spaces across all C files,
    # else the build fails
    find . \
      -name '*.c' \
      -exec sed -i 's#\xc2\xa0# #g' {} +
  '';

  nativeBuildInputs = [
    git
    scons
    finalAttrs.passthru.customPython
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    criterion
    libsodium
    ncurses
    parson
    sqlite
  ]
  ++ lib.optional withSystemMsgpackCmp msgpack-cmp
  ++ lib.optional withSystemQcbor qcbor;

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-implicit-function-declaration"
    "-Wno-incompatible-pointer-types"
    "-Wno-unused-variable"
  ];

  buildPhase = ''
    runHook preBuild

    mkdir build
    scons -C build -f ../SConstruct

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{include,lib,bin}
    cp -r include/neuropil* $out/include
    cp -r build/neuropil/lib/* $out/lib
    cp -r build/neuropil/bin/* $out/bin

    runHook postInstall
  '';

  dontStrip = withDebug;

  passthru.updateScript = nix-update-script { };
  passthru.customPython = python3.withPackages (p: [
    p.requests
  ]);

  meta = {
    description = "Secure & distributed M2M cybersecurity mesh";
    # https://pi-lar.gitlab.io/neuropil/intro.html#introduction
    longDescription = ''
      Neuropil is a small c-library which by default adds two layers of
      encryption to communication channels.

      It allows you to address identities (a device, an application, a service
      or a person) worldwide without compromise for privacy or security
      requirements.

      The project embraces modern concepts like named-data networks,
      self-sovereign identities, zero trust architectures and attributes based
      access control to increase the cybersecurity level of its users beyond
      the current state-of-technology.

      In effect its users will benefit from the new way of secure, scalable and
      souvereign data integration to easily comply with legal, organizational,
      operational and compliance regulations and requirements.
    '';
    homepage = "https://gitlab.com/pi-lar/neuropil";
    mainProgram = "neuropil";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
      osl3
      # src/ext_tools
      bsd2
      gpl2Plus
      x11
    ];
    maintainers = with lib.maintainers; [ eljamm ];
    teams = with lib.teams; [ ngi ];
  };
})
