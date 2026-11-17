{
  lib,
  stdenv,
  fetchFromGitHub,
  chez,
  makeWrapper,
  pkg-config,
  xxd,
  lz4,
  zlib,
  ncurses,
  openssl,
  cacert,
  git,
  unzip,
  libuuid,
  libiconv,
  versionCheckHook,
}:

let
  runtimePath = lib.makeBinPath [
    git
    unzip
  ];
  opensslLibraryPath = lib.makeLibraryPath [ openssl ];
  cacertFile = "${cacert}/etc/ssl/certs/ca-bundle.crt";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "jolt";
  version = "0.8.27";

  src = fetchFromGitHub {
    owner = "jolt-lang";
    repo = "jolt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g/ObaXyQf+JYaRPBhejV0OI36ChaCQ4giGyF0sxmdcQ=";
    fetchSubmodules = true;
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    chez
    makeWrapper
    pkg-config
    xxd
  ];

  buildInputs = [
    lz4
    zlib
    ncurses
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libuuid ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  env = {
    JOLT_VERSION = finalAttrs.version;
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild
    scheme --script host/chez/build-jolt.ss release target/release/jolt
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 target/release/jolt $out/bin/jolt
    runHook postInstall
  '';

  postFixup = ''
    wrapProgram "$out/bin/jolt" \
      --prefix PATH : "${runtimePath}" \
      --set-default JOLT_OPENSSL_LIBDIR "${opensslLibraryPath}" \
      --set-default SSL_CERT_FILE "${cacertFile}"
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Clojure implementation on Chez Scheme";
    homepage = "https://github.com/jolt-lang/jolt";
    changelog = "https://github.com/jolt-lang/jolt/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ crimeminister ];
    platforms = lib.platforms.unix;
    mainProgram = "jolt";
  };
})
