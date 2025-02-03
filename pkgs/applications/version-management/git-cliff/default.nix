{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-GRvZ9jdooduFylTGgUQNjdnD2Aa+jT5faV0/c3GBpqw=";
  };

  cargoHash = "sha256-vgVTHTEKfjWJzxDQ5w0dwp9qxyN5sgbBseXHN25bx9o=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security SystemConfiguration
  ];

  meta = with lib; {
    description = "Highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
    mainProgram = "git-cliff";
  };
}
