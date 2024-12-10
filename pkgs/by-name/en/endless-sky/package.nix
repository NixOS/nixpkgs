{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  libpng,
  libjpeg,
  glew,
  openal,
  scons,
  libmad,
  libuuid,
}:

stdenv.mkDerivation rec {
  pname = "endless-sky";
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "endless-sky";
    repo = "endless-sky";
    rev = "v${version}";
    sha256 = "sha256-bqhltxkoqDdmddOBZ1f3I29AxGm5buUXpjjFwefemEM=";
  };

  patches = [
    ./fixes.patch
  ];

  postPatch = ''
    # the trailing slash is important!!
    # endless sky naively joins the paths with string concatenation
    # so it's essential that there be a trailing slash on the resources path
    substituteInPlace source/Files.cpp \
      --replace '%NIXPKGS_RESOURCES_PATH%' "$out/share/games/endless-sky/"
  '';

  preBuild = ''
    export AR="${stdenv.cc.targetPrefix}gcc-ar"
  '';

  enableParallelBuilding = true;

  buildInputs = [
    SDL2
    libpng
    libjpeg
    glew
    openal
    scons
    libmad
    libuuid
  ];

  prefixKey = "PREFIX=";

  meta = with lib; {
    description = "Sandbox-style space exploration game similar to Elite, Escape Velocity, or Star Control";
    mainProgram = "endless-sky";
    homepage = "https://endless-sky.github.io/";
    license = with licenses; [
      gpl3Plus
      cc-by-sa-30
      cc-by-sa-40
      publicDomain
    ];
    maintainers = with maintainers; [ _360ied ];
    platforms = platforms.linux; # Maybe other non-darwin Unix
  };
}
