{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "git-cliff";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "git-cliff";
    rev = "v${version}";
    hash = "sha256-pOmSVySn8QUpFLTXFXBVm1KTX9ny221t1xSxBRHkljQ=";
  };

  cargoHash = "sha256-y0XTvSV8JE6nmSJfJKLw2Gt/D/yX12kbx2+RHqVCVWI=";

  # attempts to run the program on .git in src which is not deterministic
  doCheck = false;

  buildInputs = lib.optionals stdenv.isDarwin [
    Security SystemConfiguration
  ];

  meta = with lib; {
    description = "A highly customizable Changelog Generator that follows Conventional Commit specifications";
    homepage = "https://github.com/orhun/git-cliff";
    changelog = "https://github.com/orhun/git-cliff/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ siraben ];
  };
}
