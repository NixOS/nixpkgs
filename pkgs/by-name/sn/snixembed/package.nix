{
  fetchFromSourcehut,
  gtk3,
  lib,
  libdbusmenu-gtk3,
  nix-update-script,
  pkg-config,
  stdenv,
  vala,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snixembed";
  version = "0.3.3";

  src = fetchFromSourcehut {
    owner = "~steef";
    repo = "snixembed";
    rev = finalAttrs.version;
    hash = "sha256-co32Xlklg6KVyi+xEoDJ6TeN28V+wCSx73phwnl/05E=";
  };

  nativeBuildInputs = [
    pkg-config
    vala
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildInputs = [
    gtk3
    libdbusmenu-gtk3
  ];

  doInstallCheck = true;

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Proxy StatusNotifierItems as XEmbedded systemtray-spec icons";
    homepage = "https://git.sr.ht/~steef/snixembed";
    changelog = "https://git.sr.ht/~steef/snixembed/refs/${finalAttrs.version}";
    license = lib.licenses.isc;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      nick-linux
    ];
    mainProgram = "snixembed";
  };
})
