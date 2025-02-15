{
  fetchFromGitHub,
  ctags,
  lib,
  makeWrapper,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ptags";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "dalance";
    repo = "ptags";
    rev = "v${version}";
    sha256 = "sha256-bxp38zWufqS6PZqhw8X5HR5zMRcwH58MuZaJmDRuiys=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-zzbGyfuzJXB/Rf/cm4JTVfjx2rWz1iTnELokie6qBrw=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    # `ctags` must be accessible in `PATH` for `ptags` to work.
    wrapProgram "$out/bin/ptags" \
      --prefix PATH : "${lib.makeBinPath [ ctags ]}"
  '';

  # Sanity check.
  checkPhase = ''
    $releaseDir/ptags --help > /dev/null
  '';

  meta = with lib; {
    description = "Parallel universal-ctags wrapper for git repository";
    mainProgram = "ptags";
    homepage = "https://github.com/dalance/ptags";
    maintainers = with maintainers; [ pamplemousse ];
    license = licenses.mit;
  };
}
