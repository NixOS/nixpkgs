{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    tag = "v${version}";
    hash = "sha256-OszKEWrpXEyi+0ayTzqy6O+cMZ/AVmesN3QJWCAHF7Q=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GIAGy0yLV7hRUk7cMEKxjmXJxpZSNyMXICEGr4vfIxc=";

  meta = with lib; {
    description = "Tool to list listening sockets";
    license = licenses.mit;
    maintainers = [
      maintainers.k900
      maintainers.jcaesar
    ];
    platforms = platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
    mainProgram = "lls";
  };
}
