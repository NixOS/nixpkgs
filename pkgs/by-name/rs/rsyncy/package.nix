{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  rsync,
}:

buildGoModule (finalAttrs: {
  pname = "rsyncy";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "laktak";
    repo = "rsyncy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sy0aMYT7xrBfXB3YxLGL49jKVnRpWo5k+3mjQNAOagU=";
  };

  vendorHash = "sha256-vexWkbUQdkWrDJVvu2T4z4hbiCANuW0qLNFNSiTmYtY=";

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
