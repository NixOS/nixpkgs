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
  pname = "go-librespot";
  version = "0.7.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devgianlu";
    repo = "go-librespot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TJQMfZRuWDu83QZeCU+EQ90WX6gT5+nXbYRIqfvXRp8=";
  };

  vendorHash = "sha256-kCzzybOEP4Tp7OGFZBjIP1FgcQ9u+lgO3931gbaG9hA=";

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
      emilylange
    ];
  };
})
