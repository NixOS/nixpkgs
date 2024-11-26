{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "crumbs";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "fasseg";
    repo = "crumbs";
    rev = version;
    sha256 = "0jjvydn4i4n9xv8vsal2jxpa95mk2lw6myv0gx9wih242k9vy0l7";
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

  meta = with lib; {
    description = "Bookmarks for the command line";
    homepage = "https://github.com/fasseg/crumbs";
    license = licenses.wtfpl;
    platforms = platforms.all;
    maintainers = with maintainers; [ thesola10 ];
    mainProgram = "crumbs";
  };
}
