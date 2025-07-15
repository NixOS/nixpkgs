{
  lib,
  buildGoModule,
  fetchurl,
  fetchFromGitHub,
}:

let
  version = "1.8.3";

  # TODO: must build the extension instead of downloading it. But since it's
  # literally an asset that is indifferent regardless of the platform, this
  # might be just enough.
  webext = fetchurl {
    url = "https://github.com/browsh-org/browsh/releases/download/v${version}/browsh-${version}.xpi";
    hash = "sha256-wLctfGHDCgy3nMG/nc882qNjHOAp8VeOZcEWJD7QThY=";
  };

in

buildGoModule rec {
  inherit version;

  pname = "browsh";

  sourceRoot = "${src.name}/interfacer";

  src = fetchFromGitHub {
    owner = "browsh-org";
    repo = "browsh";
    rev = "v${version}";
    hash = "sha256-Abna1bAaqOT44zZJsObLMR5fTW2xlWBg1M0JYH0Yc6g=";
  };

  vendorHash = "sha256-481dC7UrNMnb1QswvK2FqUiioTZ9xJP4dSd3rvRkqro=";

  preBuild = ''
    cp "${webext}" src/browsh/browsh.xpi
  '';

  # Tests require network access
  doCheck = false;

  meta = with lib; {
    description = "Fully-modern text-based browser, rendering to TTY and browsers";
    mainProgram = "browsh";
    homepage = "https://www.brow.sh/";
    maintainers = with maintainers; [
      kalbasit
      siraben
    ];
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
