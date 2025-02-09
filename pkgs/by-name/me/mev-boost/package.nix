{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "mev-boost";
  version = "1.6";
  src = fetchFromGitHub {
      owner = "flashbots";
      repo = "mev-boost";
      rev = "v${version}";
      hash = "sha256-vzgX9irpI5i85bohppyL5KWQuf71SryRu1gkhWSCVKk=";
  };

  vendorHash = "sha256-xw3xVbgKUIDXu4UQD5CGftON8E4o1u2FcrPo3n6APBE=";

  meta = with lib; {
    description = "Ethereum block-building middleware";
    homepage = "https://github.com/flashbots/mev-boost";
    license = licenses.mit;
    mainProgram = "mev-boost";
    maintainers = with maintainers; [ ekimber ];
    platforms = platforms.unix;
  };
}
