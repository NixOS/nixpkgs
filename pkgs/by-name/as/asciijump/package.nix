{
  lib,
  stdenv,
  ctags,
  fetchFromGitLab,
  slang,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asciijump";
  version = "1.0.2_beta-12";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "games-team";
    repo = "asciijump";
    tag = "debian/${finalAttrs.version}";
    hash = "sha256-fD/5tWg/GzSfVYvUWsz1FHXhLx9ud0JRMkM9NhVePdA=";
  };

  patchPhase = ''
    for file in $(cat debian/patches/series); do
      echo "$file:"
      patch -p1 < debian/patches/$file
    done
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  NIX_CFLAGS_COMPILE = [ "-fsigned-char" ];

  nativeBuildInputs = [ ctags ];
  buildInputs = [ slang ];

  postInstall = ''
    rm -rf $out/var
  '';

  meta = {
    description = "Small and funny ASCII-art game about ski jumping";
    homepage = "https://salsa.debian.org/games-team/asciijump";
    changelog = "https://salsa.debian.org/games-team/asciijump/-/blob/${finalAttrs.src.tag}/debian/changelog";
    license = lib.licenses.gpl2Plus;
    mainProgram = "asciijump";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
