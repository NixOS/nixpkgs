{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libunwind
}:

rustPlatform.buildRustPackage rec {
  pname = "bugstalker";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${version}";
    hash = "sha256-JacRt+zNwL7hdpdh5h9Mxztqi47f5eUbcZyx6ct/5Bc=";
  };

  cargoHash = "sha256-ljT7Dl9553sfZBqTe6gT3iYPH+D1Jp9ZsyGVQGOekxw=";

  buildInputs = [ libunwind ];

  nativeBuildInputs = [ pkg-config ];

  # Tests require rustup.
  doCheck = false;

  meta = {
    description = "Rust debugger for Linux x86-64";
    homepage = "https://github.com/godzie44/BugStalker";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "bs";
    platforms = [ "x86_64-linux" ];
  };
}
