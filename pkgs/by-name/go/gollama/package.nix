{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
let
  inherit (lib) licenses maintainers platforms;
in
buildGoModule rec {
  pname = "gollama";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "Gaurav-Gosain";
    repo = "gollama";
    rev = "refs/tags/v${version}";
    hash = "sha256-bXL7FpWpK1uUR31Y16ZwTDayLi32p10SmXwif905RfA=";
  };

  vendorHash = "sha256-a1r61QfdZ0z0lVDojjJxHSlpaSZp8Ng4bt9XOgt1HIU=";

  meta = {
    description = "Your offline conversational AI companion";
    homepage = "https://github.com/Gaurav-Gosain/gollama";
    changelog = "https://github.com/Gaurav-Gosain/gollama/releases/tag/v${version}";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ humaidq ];
    mainProgram = "gollama";
  };
}
