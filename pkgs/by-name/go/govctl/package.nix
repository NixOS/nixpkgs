{
  lib,
  fetchFromGitHub,
  gitUpdater,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "govctl";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "govctl-org";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-eNteRJSghzIKApmDAUJGUlPVe8WxNUD7LhWx9sKEUW4=";
  };

  cargoHash = "sha256-IWS4V4dBEFSf3S5osnexbj856WVspyANcaPE6VDbSXg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ openssl ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/govctl-org/govctl";
    description = "Opinionated CLI tool to enforce RFC-driven AI coding";
    license = licenses.mit;
    maintainers = with maintainers; [ waelwindows ];
    mainProgram = "govctl";
  };
}
