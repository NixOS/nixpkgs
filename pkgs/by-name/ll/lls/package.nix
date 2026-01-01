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

<<<<<<< HEAD
  meta = {
    description = "Tool to list listening sockets";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.k900
      lib.maintainers.jcaesar
    ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Tool to list listening sockets";
    license = licenses.mit;
    maintainers = [
      maintainers.k900
      maintainers.jcaesar
    ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://github.com/jcaesar/lls";
    mainProgram = "lls";
  };
}
