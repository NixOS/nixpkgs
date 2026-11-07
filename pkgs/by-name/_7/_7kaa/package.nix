{
  lib,
  stdenv,
  gccStdenv,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  fetchurl,
  fetchgit,
  openal,
  enet,
  SDL2,
  curl,
  gettext,
  libiconv,
  makeWrapper,
}:
let
  version = "2.15.7";

  musicVersion = lib.versions.majorMinor version;
  music = stdenv.mkDerivation {
    pname = "7kaa-music";
    version = musicVersion;

    src = fetchurl {
      url = "https://www.7kfans.com/downloads/7kaa-music-${musicVersion}.tar.bz2";
      hash = "sha256-sNdntuJXGaFPXzSpN0SoAi17wkr2YnW+5U38eIaVwcM=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';

    meta.license = lib.licenses.unfree;
  };
in
gccStdenv.mkDerivation (finalAttrs: {
  pname = "7kaa";
  inherit version;

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchgit {
    url = "https://git.code.sf.net/p/skfans/7kaa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XnRBZjdioZIBbmhh/IK2NpqhB/yno08hkV05XBt+1b0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    makeWrapper
    pkg-config
    SDL2
  ];

  buildInputs = [
    openal
    enet
    curl
    gettext
    libiconv
  ];

  preAutoreconf = ''
    autoupdate
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=format-security";

  hardeningDisable = lib.optionals stdenv.hostPlatform.isDarwin [
    "stackprotector"
  ];

  postInstall = ''
    mkdir $out/share/7kaa/MUSIC
    cp -R ${music}/MUSIC $out/share/7kaa/
    cp ${music}/COPYING-Music.txt $out/share/7kaa/MUSIC
    cp ${music}/COPYING-Music.txt $out/share/doc/7kaa

    wrapProgram $out/bin/7kaa \
      --set SKDATA $out/share/7kaa/
  '';

  # Multiplayer is auto-disabled for non-x86 system

  meta = {
    changelog = "https://sourceforge.net/p/skfans/7kaa/ci/v${finalAttrs.version}/tree/README";
    homepage = "https://www.7kfans.com";
    description = "GPL release of the Seven Kingdoms with multiplayer (available only on x86 platforms)";
    mainProgram = "7kaa";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.x86_64 ++ lib.platforms.aarch64;
    maintainers = with lib.maintainers; [ _1000101 ];
  };
})
