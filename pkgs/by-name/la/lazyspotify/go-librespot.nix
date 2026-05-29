{
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  flac,
  lib,
  libogg,
  libvorbis,
  pkg-config,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "lazyspotify-librespot";
  version = "0.7.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "dubeyKartikay";
    repo = "go-librespot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hq9Qk8f8oKzpBwsbLNAvPO7qam3bh4L4RPUQC67/NZY=";
  };

  vendorHash = "sha256-5J5i2Wc0zHCdvJ3aUkftXeMKS5X8jWimup0Ir4HLuS8=";

  subPackages = [ "cmd/daemon" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    flac
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
