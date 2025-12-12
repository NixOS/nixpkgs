{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "autotiling-rs";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${version}";
    sha256 = "sha256-21XIKZ2rzuQMpkaOhGu1pg4J3OGOzHNQ20Rcw1V4BfI=";
  };

  cargoHash = "sha256-+5GibhSkiKmgRrESKrliKLrrtUQ7iv2sFz46OFwAIwE=";

  meta = {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "autotiling-rs";
  };
}
