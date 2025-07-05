{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "autotiling-rs";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "ammgws";
    repo = "autotiling-rs";
    rev = "v${version}";
    sha256 = "sha256-rihNlKaESxIEQ61FP6PzIg82yuwQ/R4GX5BA0Ss+I5w=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mXuI+kA8J2Bhli6HiX9h72i61cRbByKJQtUHHjCUza8=";

  meta = with lib; {
    description = "Autotiling for sway (and possibly i3)";
    homepage = "https://github.com/ammgws/autotiling-rs";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "autotiling-rs";
  };
}
