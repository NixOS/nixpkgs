{
  lib,
  stdenv,
  asciidoctor,
  fetchFromGitLab,
  ncurses,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bluemoon";
  version = "2.13";

  src = fetchFromGitLab {
    owner = "esr";
    repo = "bluemoon";
    tag = finalAttrs.version;
    hash = "sha256-zZ9saECg5fqC+VEMHi4TtJopOo9R8dKmxlZ8mKN5khU=";
  };

  postPatch = ''
    substituteInPlace Makefile \
      --replace-quiet '//usr' '/usr' \
      --replace-fail '$(DESTDIR)/usr' '/usr' \
      --replace-fail ' /usr' ' ${placeholder "out"}'
  '';

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [ asciidoctor ];
  buildInputs = [ ncurses ];

  buildFlags = [
    "bluemoon"
    "bluemoon.6"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Blue Moon card solitaire game with a TUI";
    homepage = "https://gitlab.com/esr/bluemoon";
    changelog = "https://gitlab.com/esr/bluemoon/-/blob/${finalAttrs.version}/NEWS.adoc";
    license = lib.licenses.bsd2;
    mainProgram = "bluemoon";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ Zaczero ];
  };
})
