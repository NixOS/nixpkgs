{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
}:

rustPlatform.buildRustPackage {
  pname = "leetcode-tui";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "akarsh1995";
    repo = "leetcode-tui";
    rev = "53a4b89c135bace07f4002e7646c5fdd06181a61";
    sha256 = "1iz5dv2aq7ldl7cq6qdgx2rxrbhkxyng6b6v0fndhly59bhg6p4a";
  };

  cargoHash = "sha256-JJMsJxadEHgo7Xk57zsjchEYZPUL31eJ3BmDA/f4rxI=";

  OPENSSL_NO_VENDOR = 1;
  cargoBuildFlags = [
    "-p"
    "leetcode-tui-rs"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests require network access to LeetCode API
  doCheck = false;

  meta = {
    description = "Terminal UI for LeetCode stats problems";
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
    license = lib.licenses.mit;
    mainProgram = "leetui";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ Ra77a3l3-jar ];
  };
}
