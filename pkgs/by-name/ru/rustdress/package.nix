{
  lib,
  fetchFromGitHub,
  rustPlatform,
  cmake,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustdress";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "niteshbalusu11";
    repo = "rustdress";
    tag = "v${version}";
    hash = "sha256-vADuzT1q6nzNMtSykhmfaX6SMkWxQHHpKD/NrfWsCgI=";
  };

  cargoHash = "sha256-LyWVuy/b1oaeBL2s1VUXHJefcgg13JqqEh24WSdk5nI=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl
  ];

  meta = {
    description = "Self-hosted Lightning Address Server";
    homepage = "https://github.com/niteshbalusu11/rustdress";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jordan-bravo ];
    mainProgram = "rustdress";
  };
}
