{
  lib,
  rustPlatform,
  fetchzip,
  pkg-config,
  fuse3,
}:

rustPlatform.buildRustPackage rec {
  pname = "redoxer";
  version = "0.2.43";

  src = fetchzip {
    url = "https://gitlab.redox-os.org/redox-os/redoxer/-/archive/${version}/redoxer-${version}.tar.gz";
    hash = "sha256-PHebvrK/MwgaREhFxr8LwWL+46GNIKV9prDTvucYF1g=";
    stripRoot = false;
  };

  sourceRoot = "source/redoxer-${version}";

  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  buildInputs = [ fuse3 ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Tool used to build/run programs inside of a Redox VM";
    homepage = "https://gitlab.redox-os.org/redox-os/redoxer";
    license = licenses.mit;
    mainProgram = "redoxer";
    maintainers = with maintainers; [ justsoup312 ];
  };
}
