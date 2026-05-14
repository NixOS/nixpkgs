{
  fetchFromGitHub,
  lib,
  stdenv,
  pkg-config,
  libao,
  json_c,
  libgcrypt,
  ffmpeg,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pianobar";
  version = "2024.12.21";

  src = fetchFromGitHub {
    owner = "PromyLOPh";
    repo = "pianobar";
    tag = finalAttrs.version;
    hash = "sha256-efmzc37Z6fjEOSzc29mowlaq3qEhyy3ta/gWMpuDJ+w=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libao
    json_c
    libgcrypt
    ffmpeg
    curl
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    changelog = "https://github.com/PromyLOPh/pianobar/raw/${finalAttrs.src.rev}/ChangeLog";
    description = "Console front-end for Pandora.com";
    homepage = "https://6xq.net/pianobar/";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit; # expat version
    mainProgram = "pianobar";
  };
})
