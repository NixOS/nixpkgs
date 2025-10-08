{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "leetcode-tui";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "akarsh1995";
    repo = "leetcode-tui";
    rev = "53a4b89c135bace07f4002e7646c5fdd06181a61";
    sha256 = "1iz5dv2aq7ldl7cq6qdgx2rxrbhkxyng6b6v0fndhly59bhg6p4a";
  };

  cargoHash = "sha256-JJMsJxadEHgo7Xk57zsjchEYZPUL31eJ3BmDA/f4rxI=";

  # Ensure openssl-sys uses Nix's OpenSSL and build the right workspace member
  OPENSSL_NO_VENDOR = 1;
  cargoBuildFlags = [ "-p" "leetcode-tui-rs" ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  doCheck = false;

  meta = with lib; {
    description = "Terminal UI for LeetCode - browse stats and manage problems from the terminal";
    longDescription = ''
      A lightweight, interactive terminal user interface for LeetCode that allows you to:
      - Browse questions grouped by categories
      - Read and solve problems in multiple programming languages
      - Submit and run solutions directly from the terminal
      - View your performance statistics
      - Search problems by ID, topic, or title
      - Work with popular problem sets like Neetcode 75

      The tool provides a resource-efficient alternative to the web interface while
      maintaining full functionality for competitive programming practice.
    '';
    homepage = "https://github.com/akarsh1995/leetcode-tui";
    license = licenses.mit;
    mainProgram = "leetui";
    platforms = platforms.all;
    maintainers = with maintainers; [ Ra77a3l3-jar ];
  };
}
