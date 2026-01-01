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
<<<<<<< HEAD
  version = "0.6.3";
=======
  version = "0.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "niteshbalusu11";
    repo = "rustdress";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vADuzT1q6nzNMtSykhmfaX6SMkWxQHHpKD/NrfWsCgI=";
  };

  cargoHash = "sha256-LyWVuy/b1oaeBL2s1VUXHJefcgg13JqqEh24WSdk5nI=";
=======
    hash = "sha256-XEXvAAnktr7gfk3y8kLtrVmg0slx5wc4dCCWT2r+Wj0=";
  };

  cargoHash = "sha256-COuHTjEy/VkfVd2/kjTKw1kiJI0XC72TEXaS8lVXsAQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
