{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "seehecht";
  version = "3.0.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = "seehecht";
    rev = "v${version}";
    hash = "sha256-KIxK0JYfq/1Bn4LOn+LzWPBUvGYMvOEuqS7GMpDRvW0=";
  };

  cargoHash = "sha256-xsZyLyw+IC17QSVEtUJWIkQiaG7JtcLWr8xypTwYMUo=";

  postInstall = ''
    ln -s $out/bin/seh $out/bin/seehecht
  '';

  meta = {
    description = "Tool to quickly open a markdown document with already filled out frontmatter";
    license = lib.licenses.lgpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ annaaurora ];
  };
}
