{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  rsync,
}:

buildGoModule (finalAttrs: {
  pname = "rsyncy";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "rsyncy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWahPfAW6m86C0jdUB8Hfmx2A3i4NLsnAWI0HVoAbcE=";
  };

  vendorHash = "sha256-xEjLMp4hbRrSvHBsuFxYsyNB7s2P876dV1NyAXycGoo=";

  ldflags = [
    "-s"
    "-w"
    "-X main.appVersion=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/rsyncy \
      --prefix PATH : "${lib.makeBinPath [ rsync ]}"
  '';

  meta = {
    description = "Progress bar wrapper for rsync";
    homepage = "https://github.com/laktak/rsyncy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marie ];
    mainProgram = "rsyncy";
  };
})
