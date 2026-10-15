{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "crumbs";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "fasseg";
    repo = "crumbs";
    rev = finalAttrs.version;
    hash = "sha256-hwK/0xREwMhTf2D7ajgVs5akbpeCKr3R7smSSGzzW0o=";
  };

  prePatch = ''
    sed -i 's|gfind|find|' crumbs-completion.fish
  '';

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    mkdir -p $out/share/fish/vendor_completions.d

    cp crumbs-completion.bash $out/share/bash-completion/completions/crumbs
    cp crumbs-completion.fish $out/share/fish/vendor_completions.d/crumbs.fish
  '';

  meta = {
    description = "Bookmarks for the command line";
    homepage = "https://github.com/fasseg/crumbs";
    license = lib.licenses.wtfpl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ thesola10 ];
    mainProgram = "crumbs";
  };
})
