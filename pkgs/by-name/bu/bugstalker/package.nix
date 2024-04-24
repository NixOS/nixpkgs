{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libunwind
}:

rustPlatform.buildRustPackage rec {
  pname = "bugstalker";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "godzie44";
    repo = "BugStalker";
    rev = "v${version}";
    hash = "sha256-16bmvz6/t8H8Sx/32l+fp3QqP5lwi0o1Q9KqDHqF22U=";
  };

  cargoHash = "sha256-kp0GZ0cM57BMpH/8lhxevnBuJhUSH0rtxP4B/9fXYiU=";

  buildInputs = [ libunwind ];

  nativeBuildInputs = [ pkg-config ];

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
