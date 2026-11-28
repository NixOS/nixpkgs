{
  lib,
  stdenv,
  makeWrapper,
  git,
  openssl,
  cacert,
  libuuid,
  fetchFromGitHub,
  chez,
  pkg-config,
  xxd,
  zlib,
  lz4,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jolt";
  version = "0.8.26";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jolt-lang";
    repo = "jolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NT42ipahzqcnopz1Pd9WYRool9pypNRuK19HbE22AA4=";
    fetchSubmodules = true;
  };

  strictDeps = true;

  nativeBuildInputs = [
    git
    makeWrapper
    chez
    pkg-config
    xxd
  ];

  buildInputs = [
    lz4
    zlib
    libuuid
    ncurses
    openssl
  ];

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    scheme --script host/chez/build-jolt.ss release target/release/jolt
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    install -m755 target/release/jolt "$out/bin/jolt"
    mkdir -p "$out/share/doc/jolt"
    cp LICENSE NOTICE "$out/share/doc/jolt/"
    cp -R licenses "$out/share/doc/jolt/licenses"
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/jolt \
      --prefix PATH : ${lib.makeBinPath [ git ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          openssl
          lz4
          zlib
        ]
      } \
      --set-default JOLT_OPENSSL_LIBDIR "${lib.makeLibraryPath [ openssl ]}" \
      --set-default SSL_CERT_FILE "${cacert}/etc/ssl/certs/ca-bundle.crt"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A Clojure implementation on Chez Scheme";
    homepage = "https://github.com/jolt-lang/jolt";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [
      dvn0
    ];
    platforms = lib.platforms.linux;
    mainProgram = "jolt";
  };
})
