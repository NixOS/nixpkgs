{
  lib,
  rustPlatform,
  fetchFromGitea,
}:

rustPlatform.buildRustPackage rec {
  pname = "didu";
  version = "2.5.2";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "annaaurora";
    repo = pname;
    rev = "v${version}";
    sha256 = "szYWRN1NZbfpshipwMMJSWJw/NG4w7I+aqwtmqpT0R0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NDri4VuTI/ZsY3ZvpWmu/2I5GpmldQaoUSzyjGlq9lE=";

  meta = with lib; {
    description = "Duration conversion between units";
    homepage = "https://codeberg.org/annaaurora/didu";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ annaaurora ];
    mainProgram = "didu";
  };
}
