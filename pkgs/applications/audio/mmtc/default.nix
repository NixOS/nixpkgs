{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "mmtc";
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "figsoda";
    repo = pname;
    rev = "v${version}";
    sha256 = "1chcnv8wql6v2vckpzvq6sxgpss7mnxaj008jdm8xalhw9d496s4";
  };

  cargoSha256 = "056mnfd0qd4pqnj3pwfi6g6f06ybvcbc7xds7lvyhghb9gs833bk";

  meta = with lib; {
    description = "Minimal mpd terminal client that aims to be simple yet highly configurable";
    homepage = "https://github.com/figsoda/mmtc";
    changelog = "https://github.com/figsoda/mmtc/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
