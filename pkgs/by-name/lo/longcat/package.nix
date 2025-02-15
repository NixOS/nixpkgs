{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.0.12";
in
buildGoModule {
  pname = "longcat";
  inherit version;

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "longcat";
    tag = "v${version}";
    hash = "sha256-MiUkI7qCN/rDJUkBCyET19CH4iYnl1HwKjRZD2dCTVM=";
  };

  vendorHash = "sha256-ka58YOoyBKLX8Z9ak2+rERXsY3rPUaOanfIFErCJCdE=";

  meta = with lib; {
    homepage = "https://github.com/mattn/longcat";
    description = "Looooooooooooooooooooooooooooooooooooooooooooooong cat";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "longcat";
    maintainers = with lib.maintainers; [
      bubblepipe
    ];
  };
}
