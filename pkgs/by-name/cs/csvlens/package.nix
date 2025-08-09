{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch2,
}:

rustPlatform.buildRustPackage rec {
  pname = "csvlens";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "YS-L";
    repo = "csvlens";
    tag = "v${version}";
    hash = "sha256-kyUfpZaOpLP8nGrXH8t9cOutXFkZsmZnPmIu3t6uaWU=";
  };

  patches = [
    (fetchpatch2 {
      # https://github.com/YS-L/csvlens/pull/129
      name = "fix-flaky-test.patch";
      url = "https://github.com/YS-L/csvlens/commit/8544e9d4179eef10e8d1a625a41c0e1ef3eb188b.patch";
      hash = "sha256-j02H+R14Hfm7ZEHFPRGqTY/GEzj5ETXp72kk7os9Zso=";
    })
  ];

  cargoHash = "sha256-lr1pqFodqgsKHRFGonXj0nG4elomiSMETulBdCLMR3w=";

  meta = with lib; {
    description = "Command line csv viewer";
    homepage = "https://github.com/YS-L/csvlens";
    changelog = "https://github.com/YS-L/csvlens/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
    mainProgram = "csvlens";
  };
}
