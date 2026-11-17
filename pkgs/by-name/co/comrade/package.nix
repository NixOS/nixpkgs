{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  ninja,
  pkg-config,
  libssh,
  openssl,
  libjuice,
  kcp,
  libdht,
  nix-update-script,
  versionCheckHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "comrade";
  version = "0.2.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dangowrt";
    repo = "comrade";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RDjjruOY5ootz5MMlIjIOaG6hngIx51mf40veADeERE=";
  };

  strictDeps = true;

  buildInputs = [
    libssh
    openssl
    libjuice
    kcp
    libdht
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  cmakeFlags = [
    # Configure tries to download a list of active STUN servers
    # so we make it fallback to 3 hardcoded servers
    (lib.cmakeBool "COMRADE_STUN_FALLBACK" true)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serverless peer-to-peer terminal sharing with tmate-like semantics";
    homepage = "https://comrade.makrotopia.org/";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [
      dvn0
    ];
    mainProgram = "comrade";
  };
})
