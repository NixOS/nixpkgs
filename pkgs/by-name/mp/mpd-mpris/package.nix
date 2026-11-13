{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "mpd-mpris";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = "mpd-mpris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EOZiOFBe5j1WsrJLj8++QsgNUZR44M6ae40KKl2Qac8=";
  };

  vendorHash = "sha256-ugJEw02jSsfObljDaup31zoQlf2HvwDRUljD7lp7Ys4=";

  subPackages = [ "cmd/mpd-mpris" ];

  postPatch = ''
    substituteInPlace services/mpd-mpris.service --replace-fail "ExecStart=" "ExecStart=$out/bin/"
  '';

  postInstall = ''
    install -Dm644 services/mpd-mpris.service -t $out/lib/systemd/user
    install -Dm644 mpd-mpris.desktop -t $out/etc/xdg/autostart
  '';

  meta = {
    description = "Implementation of the MPRIS protocol for MPD";
    homepage = "https://github.com/natsukagami/mpd-mpris";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "mpd-mpris";
  };
})
