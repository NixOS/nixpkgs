{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "figtree";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "erikdkennedy";
    repo = "figtree";
    tag = "v${finalAttrs.version}";
    hash = "sha256-owzoM0zfKYxLJCQbL1eUE0cdSLVmm+QNRUGxbsNJ37I=";
  };

  sourceRoot = "fonts";

  setSourceRoot = "sourceRoot=$(pwd)";

  installPhase = ''
    runHook preInstall
    find . -type f -iname '*.ttf' | while read f; do
      d="$out/share/fonts/truetype/figtree/$(basename "$f")"
      install -Dm644 -D "$f" "$d"
    done
    find . -type f -iname '*.otf' | while read f; do
      d="$out/share/fonts/opentype/figtree/$(basename "$f")"
      install -Dm644 -D "$f" "$d"
    done
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/erikdkennedy/figtree";
    description = "Simple and friendly geometric sans serif font";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ mrcjkb ];
    license = lib.licenses.ofl;
  };
})
