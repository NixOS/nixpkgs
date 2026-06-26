{
  lib,
  stdenv,
  fetchFromGitHub,
  fuse3,
  libarchive,
  pkg-config,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-archive";
  version = "1.22";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fuse-archive";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uE+22ONNnPqAi8zBV0v3qu3um2gNoX4/jNUA7E+UQOE=";
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
    fuse3
    libarchive
    boost
  ];

  env.NIX_CFLAGS_COMPILE = "-D_FILE_OFFSET_BITS=64";

  makeFlags = [ "prefix=${placeholder "out"}" ];

  meta = {
    inherit (fuse3.meta) platforms;
    description = "Serve an archive or a compressed file as a read-only FUSE file system";
    homepage = "https://github.com/google/fuse-archive";
    changelog = "https://github.com/google/fuse-archive/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ icyrockcom ];
    mainProgram = "fuse-archive";
  };
})
