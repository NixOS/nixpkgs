{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse,
  libarchive,
  pkg-config,
  boost,
}:

stdenv.mkDerivation rec {
  pname = "fuse-archive";
  version = "1.10";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fuse-archive";
    tag = "v${version}";
    hash = "sha256-Fta/IYKWsB4ZuPOWtGO6p6l03eoRXaO0lIGaCU3SRag=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "/usr" "$out"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace src/main.cc \
      --replace-fail "!defined(__OpenBSD__)" "!defined(__OpenBSD__) && !defined(__APPLE__)" \
      --replace-fail " | O_PATH" ""
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fuse
    libarchive
    boost
  ];

  env.NIX_CFLAGS_COMPILE = "-D_FILE_OFFSET_BITS=64";

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    inherit (fuse.meta) platforms;
    description = "Serve an archive or a compressed file as a read-only FUSE file system";
    homepage = "https://github.com/google/fuse-archive";
    changelog = "https://github.com/google/fuse-archive/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ icyrockcom ];
    mainProgram = "fuse-archive";
  };
}
