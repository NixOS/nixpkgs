{
  lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  alsa-lib,
  libnotify,
  wl-clipboard,
  xclip,
  wf-recorder,
  mpv,
}:

let
  desktopItem = makeDesktopItem {
    name = "kage";
    desktopName = "Kage";
    comment = "TUI XMPP client";
    exec = "kage";
    terminal = true;
    categories = [
      "Network"
      "Chat"
      "InstantMessaging"
    ];
  };
in
buildGoModule (finalAttrs: {
  pname = "kage";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "jim-ww";
    repo = "kage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wSDALNBTt5LYZPiPb9bYRcn+ywIeCHN2+TI3nOaoGZE=";
  };

  vendorHash = "sha256-E9cqg7ua72UcgQqg8l9dQU7I68HwWhjRmCcgg3rURO0=";

  __structuredAttrs = true;

  env.CGO_ENABLED = 1;

  ldflags = [ "-X github.com/jim-ww/kage/version.Version=${finalAttrs.version}" ];

  doCheck = false;

  buildInputs = [ alsa-lib ];
  nativeBuildInputs = [
    makeWrapper
    pkg-config
    copyDesktopItems
  ];

  desktopItems = [ desktopItem ];

  postFixup = ''
    wrapProgram $out/bin/kage --prefix PATH : ${
      lib.makeBinPath [
        libnotify
        wl-clipboard
        xclip
        wf-recorder
        mpv
      ]
    }
  '';

  meta = {
    description = "Terminal XMPP client with E2E encryption and voice calls";
    homepage = "https://github.com/jim-ww/kage";
    license = [
      lib.licenses.gpl3Only
      lib.licenses.bsd2
    ];
    maintainers = [ lib.maintainers.jim-ww ];
    mainProgram = "kage";
  };
})
