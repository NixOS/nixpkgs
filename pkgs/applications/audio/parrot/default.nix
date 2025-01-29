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
  stdenv,
  yt-dlp,
  Security,
}:
rustPlatform.buildRustPackage {
  pname = "parrot";
  version = "1.6.0-unstable-2024-02-28";

  src = fetchFromGitHub {
    owner = "aquelemiguel";
    repo = "parrot";
    rev = "fcf933818a5e754f5ad4217aec8bfb16935d7442";
    hash = "sha256-3YTXIKj1iqCB+tN7/0v1DAaMM6aJiSxBYHO98uK8KFo=";
  };

  cargoHash = "sha256-3G7NwSZaiocjgfdtmJVWfMZOHCNhC08NgolPa9AvPfE=";

  nativeBuildInputs = [
    cmake
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libopus
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

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
