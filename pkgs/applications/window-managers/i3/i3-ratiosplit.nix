{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "i3-ratiosplit";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "333fred";
    repo = "i3-ratiosplit";
    rev = "v${version}";
    sha256 = "0yfmr5zk2c2il9d31yjjbr48sqgcq6hp4a99hl5mjm2ajyhy5bz3";
  };

  cargoHash = "sha256-no5fJ5nlwyS/PVi9J5Ek3c3Rp7A3MflpReo9kwJrj6U=";

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Resize newly created windows";
    mainProgram = "i3-ratiosplit";
    homepage = "https://github.com/333fred/i3-ratiosplit";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
    platforms = platforms.linux;
  };
}
