{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "lls";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    tag = "v${version}";
    hash = "sha256-eFGyrGtH57a5iRWHWqt1h58QMdmPf2rPqHnuVj5u6PQ=";
  };

  cargoHash = "sha256-TY7s0sIeW+FgxqbbYvK3uZ2RwPLVKKhLq3DOurer+Gc=";

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
