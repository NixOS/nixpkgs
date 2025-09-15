{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  xorg,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "moribito";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "ericschmar";
    repo = "moribito";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/p7RVsz9jjPTVkEjhDsSHQmYVOsvpbb1APLGQYVjgiU=";
  };

  vendorHash = "sha256-O5OmVP5aGlc8Bz2nVAAkhCdTuonB9yXGSz5FO3FxJ1I=";

  subPackages = [ "cmd/moribito" ];

  # Clipboard support
  env.CGO_ENABLED = 1;
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ xorg.libX11 ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal LDAP explorer";
    homepage = "https://github.com/ericschmar/moribito";
    changelog = "https://github.com/ericschmar/moribito/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kumpelinus ];
    mainProgram = "moribito";
  };
})
