{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "concord";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "Cogmasters";
    repo = "concord";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-8k/W6007U1/s3vx03i1929a5RKZtpW/jOr4JDwmzwp8=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  buildInputs = [ curl ];

  meta = {
    description = "Discord API wrapper library made in C";
    homepage = "https://cogmasters.github.io/concord/";
    changelog = "https://github.com/Cogmasters/concord/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ emneo ];
    platforms = lib.platforms.unix;
  };
})
