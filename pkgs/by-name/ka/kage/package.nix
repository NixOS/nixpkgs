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
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "jim-ww";
    repo = "kage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e8F0PaaSuRY8X6TjCwshfLT1QuuITr5UhiZadSbPU4o=";
  };

  vendorHash = "sha256-YACS2POFyXwhdWchf8AjPSxjGJcX3hP3ewykcvkCqqY=";

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
