{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  pkg-config,
  which,
  xxd,
  ffmpeg,
  libcamera,
  live555,
  openssl,
  v4l-utils,
}:
stdenv.mkDerivation rec {
  pname = "camera-streamer";
  version = "0.4.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ayufan";
    repo = "camera-streamer";
    tag = "v${version}";
    hash = "sha256-umU8Rp8+wUvQCNK8OpgND/6gPD013SB6sdXSLy5UGAQ=";
    fetchSubmodules = true;
  };

  # not sure why the -Werror isn't being an issue for the project maintainer
  # my best guess is it's because the project README specifices
  # "Debian Bookworm" as a requirement which provides gcc12 by default
  postPatch = ''
    sed -i 's|git submodule update.*||' Makefile
    substituteInPlace Makefile --replace-warn "-Werror" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    which
    xxd
  ];

  buildInputs = [
    ffmpeg
    libcamera
    live555
    openssl
  ];

  dontUseCmakeConfigure = true;

  makeFlags = [
    "GIT_VERSION=${src.tag}"
    "GIT_REVISION=${src.rev}"
  ];

  installPhase = ''
    runHook preInstall

    install -D camera-streamer $out/bin/camera-streamer
    wrapProgram $out/bin/camera-streamer --prefix PATH : ${lib.makeBinPath [ v4l-utils ]}

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ayufan/camera-streamer";
    changelog = "https://github.com/ayufan/camera-streamer/releases/tag/v${version}";
    description = "High-performance low-latency camera streamer for Raspberry PI's";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ _30350n ];
    platforms = lib.platforms.linux;
    mainProgram = "camera-streamer";
  };
}
