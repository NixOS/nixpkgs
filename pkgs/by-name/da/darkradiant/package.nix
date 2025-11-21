{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  zlib,
  libjpeg,
  wxGTK32,
  libxml2,
  libsigcxx,
  libpng,
  openal,
  libvorbis,
  eigen,
  ftgl,
  freetype,
  glew,
  libX11,
  glib,
  python3,
  asciidoctor,
  libgit2,
  wrapGAppsHook3,
  installShellFiles,
  buildPlugins ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "darkradiant";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "codereader";
    repo = "DarkRadiant";
    tag = finalAttrs.version;
    hash = "sha256-y0VzTnHobW36/25/nTV49OKnUMpnsjImioMdNKoTyYA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    asciidoctor
    wrapGAppsHook3
    wxGTK32
    installShellFiles
  ];

  buildInputs = [
    zlib
    libjpeg
    wxGTK32
    libxml2
    libsigcxx
    libpng
    openal
    libvorbis
    eigen
    ftgl
    freetype
    glew
    glib
    libgit2
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ libX11 ];

  doCheck = true;

  cmakeFlags = [
    # Disabling dynamic rpath, otherwise it will not found the needed libraries within $out/lib/darkradiant
    (lib.cmakeBool "ENABLE_RELOCATION" false)
    (lib.cmakeBool "ENABLE_DM_PLUGINS" buildPlugins)
  ];

  postPatch = ''
    substituteInPlace radiantcore/CMakeLists.txt \
      --replace-fail "\$ORIGIN/.." "$out/lib/darkradiant"
  '';

  postInstall = ''
    installManPage ../man/darkradiant.1
  '';

  meta = {
    description = "Open-source level editor for Doom 3 and The Dark Mod";
    homepage = "https://github.com/codereader/DarkRadiant";
    changelog = "https://github.com/codereader/DarkRadiant/releases";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ theobori ];
    platforms = lib.platforms.unix;
    mainProgram = "darkradiant";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
