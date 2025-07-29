{
  lib,
  fetchFromGitHub,
  gcc,
  go,
  makeWrapper,
  nix-update-script,
  openssl,
  pcsclite,
  pkg-config,
  podman,
  rustPlatform,
  rustc,
  sequoia-sq,
  shared-mime-info,
  versionCheckHook,
  xz, # for liblzma
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sh4d0wup";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = "sh4d0wup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gzkh+JYwuYvdNljB6agEVd7WxqJ5lI3sseY3BlkLmXs=";
  };

  cargoHash = "sha256-FjRlKlOX78QClzhhFhkZuaOLA6XpFziSghJltlRPt20=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
  ];
  buildInputs = [
    openssl
    pcsclite
    xz
    zstd
  ];
  postInstall = ''
    wrapProgram $out/bin/sh4d0wup \
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
  '';

  checkInputs = [ sequoia-sq ];
  preCheck = ''
    export XDG_DATA_DIRS=$XDG_DATA_DIRS:${shared-mime-info}/share
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  passthru.updateScript = nix-update-script { };

  env = {
    OPENSSL_NO_VENDOR = 1;
    SH4D0WUP_GCC_BINARY = lib.getExe gcc;
    SH4D0WUP_GO_BINARY = lib.getExe go;
    SH4D0WUP_PODMAN_BINARY = lib.getExe podman;
    SH4D0WUP_RUSTC_BINARY = lib.getExe' rustc "rustc";
    SH4D0WUP_SQ_BINARY = lib.getExe sequoia-sq;
  };

  meta = {
    description = "Signing-key abuse and update exploitation framework";
    homepage = "https://github.com/kpcyrd/sh4d0wup";
    changelog = "https://github.com/kpcyrd/sh4d0wup/releases/tag/v${finalAttrs.version}";
    mainProgram = "sh4d0wup";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ kpcyrd ];
    platforms = lib.platforms.all;
  };
})
