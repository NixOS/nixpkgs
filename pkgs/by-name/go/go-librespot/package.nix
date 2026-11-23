{
  alsa-lib,
  buildGoModule,
  fetchFromGitHub,
  flac,
  lib,
  libmpg123,
  libogg,
  libvorbis,
  pkg-config,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "go-librespot";
  version = "0.10.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devgianlu";
    repo = "go-librespot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P9XWG+tmeQH5VfQzoZH72fWtBgm/23ZPlQbUUcpnH4I=";
  };

  vendorHash = "sha256-CZI3Xv1N5dZ0YV9le7mw3+awgRC2SPLxwCbS/0464+E=";

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
    "-X github.com/devgianlu/go-librespot.version=v${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/daemon $out/bin/go-librespot
  '';

  meta = {
    description = "Yet another open source Spotify client, written in Go";
    mainProgram = "go-librespot";
    homepage = "https://github.com/devgianlu/go-librespot";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sweenu
    ];
  };
})
