{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  ffmpeg,
  libopus,
  makeBinaryWrapper,
  unstableGitUpdater,
  openssl,
  pkg-config,
  yt-dlp,
}:
rustPlatform.buildRustPackage {
  pname = "parrot";
  version = "1.6.0-unstable-2024-07-12";

  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "a6c1e88a1e360d46a91bc536985db87af72245b3";
    hash = "sha256-to1SVLzw2l06cqsVOopk9KH2UyGgJ4CwWagHxaDrf4Y=";
  };

  cargoHash = "sha256-be/gGKCd8/VgcjzhyMKDl5TzAuavm1rPNYBm8RLTP90=";

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libopus
    openssl
  ];

  postInstall = ''
    wrapProgram $out/bin/parrot \
      --prefix PATH : ${
        lib.makeBinPath [
          ffmpeg
          yt-dlp
        ]
      }
  '';

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = {
    description = "Hassle-free Discord music bot";
    homepage = "https://github.com/aquelemiguel/parrot";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gerg-l ];
    mainProgram = "parrot";
  };
}
