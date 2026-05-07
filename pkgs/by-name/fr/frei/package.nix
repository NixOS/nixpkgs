{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "frei";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "alexcoder04";
    repo = "frei";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-QVoRiqQt4DJK07YcCPplxigpgIqjDeQVYyDK/KQ7gbo=";
  };

  vendorHash = null;

  meta = {
    description = "Modern replacement for free";
    homepage = "https://github.com/alexcoder04/frei";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ infinidoge ];
    mainProgram = "frei";
  };
})
