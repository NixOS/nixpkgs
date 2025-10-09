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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "niteshbalusu11";
    repo = "rustdress";
    tag = "v${version}";
    hash = "sha256-XEXvAAnktr7gfk3y8kLtrVmg0slx5wc4dCCWT2r+Wj0=";
  };

  cargoHash = "sha256-COuHTjEy/VkfVd2/kjTKw1kiJI0XC72TEXaS8lVXsAQ=";

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
