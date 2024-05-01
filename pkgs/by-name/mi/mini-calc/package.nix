{
  lib,
  rustPlatform,
  fetchFromGitHub,
  gnuplot,
  makeWrapper,
}:
rustPlatform.buildRustPackage rec {
  pname = "mini-calc";
  version = "2.13.0";

  src = fetchFromGitHub {
    owner = "coco33920";
    repo = "calc";
    rev = version;
    hash = "sha256-rvQXn0VuOjB7CSf+bDTGxjeMKpbJGhVmyDLNYSy/Mlw=";
  };

  cargoHash = "sha256-QFzrJBnGKAgDhjbbik0WP3Y1fNoHMAiWpEHfidFQGPk=";

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/mini-calc \
      --prefix PATH : "${lib.makeBinPath [ gnuplot ]}"

  '';

  meta = {
    description = "A fully-featured minimalistic configurable calculator written in Rust";
    changelog = "https://github.com/coco33920/calc/blob/${version}/CHANGELOG.md";
    homepage = "https://calc.nwa2coco.fr";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "mini-calc";
    platforms = lib.platforms.unix;
  };
}
