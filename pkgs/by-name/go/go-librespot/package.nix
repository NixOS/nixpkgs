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
  version = "0.10.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devgianlu";
    repo = "go-librespot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mBVgDSQiyH3y9hr2J8xCkG9taTrThcXCfqQ6J2pSiJE=";
  };

  vendorHash = "sha256-fxB99qZE+U355iKJHIl7LgxqHmYgCiU1FpbyObTXVcQ=";

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
      emilylange
    ];
  };
})
