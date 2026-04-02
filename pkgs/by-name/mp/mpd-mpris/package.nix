{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule (finalAttrs: {
  pname = "mpd-mpris";
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "natsukagami";
    repo = "mpd-mpris";
    tag = "v${finalAttrs.version}";
    hash = "sha256-w8OH34JW++OYLpNIHfQvc45dFyU/wVWVa+vEwWb8VqU=";
  };

  vendorHash = "sha256-ugJEw02jSsfObljDaup31zoQlf2HvwDRUljD7lp7Ys4=";

  subPackages = [ "cmd/mpd-mpris" ];

  patches = [
    (fetchpatch {
      url = "https://github.com/natsukagami/mpd-mpris/commit/1591f15548aed0f9741d723f24fb505cb24fafe8.patch";
      hash = "sha256-6ZqR4woKiIjwLxyafmidTM8eBXtvBzKNXZvtS1+KKKI=";
    })
  ];

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
