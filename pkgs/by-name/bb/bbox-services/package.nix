{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "bbox-services";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "bbox-services";
    repo = "bbox";
    rev = "v${version}";
    hash = "sha256-NI6EL9UPqv1OtvEySGpk1jfHOykOvkTELkH+qR3dL3w=";
  };

  cargoHash = "sha256-ofby7fHgybRE4inx0n28glwqHcddKTo+hKN/JkmR22I=";

  nativeBuildInputs = [
    protobuf
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optional stdenv.isDarwin darwin.apple_sdk.frameworks.Security;

  meta = with lib; {
    description = "Composable spatial services";
    homepage = "https://www.bbox.earth/";
    changelog = "https://github.com/bbox-services/bbox/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = teams.geospatial.members;
    mainProgram = "";  # FIXME
    platforms = platforms.unix;
  };
}
