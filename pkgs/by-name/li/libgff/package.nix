{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgff";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "COMBINE-lab";
    repo = "libgff";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OgXnNGIgWZDIChRdEfmHwvl+oQM03V3a/HnndGLjcHk=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(ver_patch 0)" "set(ver_patch 1)"
  '';

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Lightweight GTF/GFF parsers exposing a C++ interface";
    homepage = "https://github.com/COMBINE-lab/libgff";
    downloadPage = "https://github.com/COMBINE-lab/libgff/releases";
    changelog = "https://github.com/COMBINE-lab/libgff/releases/tag/" + "v${finalAttrs.version}";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.kupac ];
  };
})
