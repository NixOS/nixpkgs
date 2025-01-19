{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "display3d";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "renpenguin";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1EAqnLlX/J9KkPKwa1LlLt8pvIS/eZth1OgVei82eP4=";
  };

  cargoHash = "sha256-VKnB5iiEAFB4rE2le0KZyqvDSrnLzDGRirmR9q11NRE=";

  meta = {
    description = "CLI for rendering and animating 3D objects";
    homepage = "https://github.com/renpenguin/display3d";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renpenguin ];
    mainProgram = "display3d";
  };
}
