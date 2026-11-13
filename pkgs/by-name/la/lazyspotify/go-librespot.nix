{
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  flac,
  lib,
  libmpg123,
  libogg,
  libvorbis,
}:
buildGoModule (finalAttrs: {
  pname = "lazyspotify-librespot";
  version = "0.8.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dubeyKartikay";
    repo = "go-librespot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HAuBSgf+15IZJENStS30Pc3BhOWkzBstA5sUNfjIO98=";
  };

  vendorHash = "sha256-WLyKs35MxCxs96hG6FTYsLhDKYDmhg6125i22kW+K7M=";

  subPackages = [ "cmd/daemon" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    flac
    libmpg123
    libogg
    libvorbis
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/devgianlu/go-librespot.version=v${finalAttrs.version}"
  ];

  # rename the generic daemon binary for identification
  postInstall = ''
    install -Dm755 $out/bin/daemon $out/bin/lazyspotify-librespot
    rm $out/bin/daemon
  '';

  meta = {
    description = "Librespot daemon tailored for lazyspotify";
    mainProgram = "lazyspotify-librespot";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eConnah ];
  };
})
