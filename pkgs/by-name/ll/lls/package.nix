{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "lls";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "jcaesar";
    repo = "lls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eFGyrGtH57a5iRWHWqt1h58QMdmPf2rPqHnuVj5u6PQ=";
  };

  cargoHash = "sha256-TY7s0sIeW+FgxqbbYvK3uZ2RwPLVKKhLq3DOurer+Gc=";

  meta = {
    description = "Tool to list listening sockets";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.k900
      lib.maintainers.jcaesar
    ];
    platforms = lib.platforms.linux;
    homepage = "https://github.com/jcaesar/lls";
    mainProgram = "lls";
  };
})
