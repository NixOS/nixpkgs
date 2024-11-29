{
  lib,
  rustPlatform,
  fetchpatch,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "emplace";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "tversteeg";
    repo = "emplace";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-FZ+lvf5HRSruUdmkm/Hqz0aRa95SjfIa43WQczRCGNg=";
  };

  cargoPatches = [
    (fetchpatch {
      url = "https://github.com/tversteeg/emplace/pull/397/commits/fe32ab280234b1fb1a81a22f78bbc8af188b5fa7.patch";
      hash = "sha256-9O0J9cJlXUGdQ9fqWeW8OIFA48qlYxGl+2yHHt3MaMU=";
    })
  ];

  cargoHash = "sha256-0BYAJOHymBVAssNfU5nPYTSvPbLEDCKoRVovIm6evUQ=";

  meta = {
    description = "Mirror installed software on multiple machines";
    homepage = "https://github.com/tversteeg/emplace";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "emplace";
  };
}
