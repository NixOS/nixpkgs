{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kl2zn6ir3w75ny25ksgxl93vlyb13gzx2795zyimqqnsrdpbbrf";
  };

  cargoSha256 = "0sddsm0jys1bsj2bsr39lcyx8k2hzw17nlsv6aql0v82x8qbsiv4";

  meta = with lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
