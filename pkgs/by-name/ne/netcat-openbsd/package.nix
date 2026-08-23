{
  lib,
  stdenv,
  fetchFromGitLab,
  quilt,
  pkg-config,
  libbsd,
  installShellFiles,
  strace,
  iproute2,
  procps,
  util-linux,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "netcat-openbsd";
  version = "1.238-1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "debian";
    repo = "netcat-openbsd";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-CCxPZmZlTRNcQ985zf1RVYE4m3OHTM8FFWol1g8Osjc=";
  };

  postPatch = ''
    QUILT_PATCHES=debian/patches quilt push -a
  '';

  outputs = [
    "out"
    "man"
  ];

  doCheck = true;

  nativeBuildInputs = [
    quilt
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    libbsd
  ];

  nativeCheckInputs = [
    strace
    iproute2
    procps
    util-linux
  ];

  installPhase = ''
    runHook preInstall

    installBin nc
    installManPage nc.1

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    substituteInPlace debian/tests/client-server debian/checks/netcat \
      --replace-fail 'PATH="/usr/bin:/bin"' ""
    patchShebangs debian/tests/client-server debian/checks/netcat

    # normally built by debian/rules
    $CC -shared -o debian/checks/readpassphrase${stdenv.hostPlatform.extensions.sharedLibrary} debian/checks/readpassphrase.c
    $CC -o debian/checks/sun_path-size debian/checks/sun_path-size.c

    # name resolution does not really exists in sandbox
    rm debian/checks/07-name-resolution

    debian/tests/client-server
    debian/checks/netcat

    runHook postCheck
  '';

  meta = {
    description = "TCP/IP swiss army knife. OpenBSD variant";
    homepage = "https://salsa.debian.org/debian/netcat-openbsd";
    maintainers = with lib.maintainers; [ artturin ];
    license = with lib.licenses; [
      bsd2
      bsd3
    ];
    platforms = lib.platforms.unix;
    mainProgram = "nc";
    # never built on aarch64-darwin since first introduction in nixpkgs
    badPlatforms = lib.platforms.darwin;
  };
})
