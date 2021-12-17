{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "verco";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "vamolessa";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-H8rDaRVU3G3iuBv0Tz/YOuYbL2k8wEoEIIEG7hjU6eM=";
  };

  cargoSha256 = "sha256-4Ou/stedL3WCY4Awsl++lc5fZ9gxd4uorf4G2/0DiPc=";

  meta = with lib; {
    description = "A simple Git/Mercurial/PlasticSCM tui client based on keyboard shortcuts";
    homepage = "https://vamolessa.github.io/verco";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
  };
}
