{
  stdenv,
  cmake,
  fetchFromGitHub,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "chuffed";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "chuffed";
    repo = "chuffed";
    tag = finalAttrs.version;
    hash = "sha256-D4HEcCDcJi05AL9suc7Twtf/wjpwBkLEeumGY3nNi5g=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/chuffed/chuffed";
    description = "The Chuffed CP solver";
    longDescription = "Chuffed is a state of the art lazy clause solver designed from the ground up with lazy clause generation in mind.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaanonim ];
    platforms = lib.platforms.all;
  };
})
