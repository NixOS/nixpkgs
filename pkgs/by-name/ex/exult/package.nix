{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  autoconf-archive,
  autoreconfHook,
  libogg,
  libvorbis,
  libx11,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  zlib,
  enableTools ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exult";
  version = "1.12.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "exult";
    repo = "exult";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rAUg8RoPsou1g27MZ84vFc0uDvUGzLXkGj33Vbsjlr8=";
  };

  outputs = [
    "out"
    "doc"
    "man"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace macosx/macosx.am \
      --replace-fail '$(DESTDIR)/Applications/' "$out/Applications/"
  '';

  nativeBuildInputs = [
    autoconf-archive
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    libogg
    libvorbis
    libx11
    zlib
  ];

  configureFlags = [ (lib.enableFeature enableTools "tools") ];
  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  enableParallelBuilding = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--use-github-releases"
      "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Recreation of Ultima VII for modern operating systems";
    longDescription = ''
      Ultima VII, an RPG from the early 1990's, still has a huge following. But,
      being a DOS game with a very nonstandard memory manager, it is difficult
      to run it on the latest computers. Exult is a project that created an
      Ultima VII game engine that runs on modern operating systems, capable of
      using the data and graphics files that come with the game. Exult aims to
      let those people who own Ultima VII play the game on modern hardware, in
      as close to (or perhaps even surpassing) its original splendor as is
      possible.
    '';
    homepage = "https://exult.info";
    changelog = "https://github.com/exult/exult/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ keenanweaver ];
    platforms = lib.platforms.unix;
    mainProgram = "exult";
  };
})
