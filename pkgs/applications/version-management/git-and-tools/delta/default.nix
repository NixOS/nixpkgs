{ lib, fetchFromGitHub, rustPlatform, llvmPackages }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "0cpd60861k9nd2gbzyb2hg5npnkgvsnyrvv7mlm30vb1833gz94z";
  };

  LLVM_CONFIG_PATH = "${llvmPackages.llvm}/bin/llvm-config";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoSha256 = "12gl50q5hf6nq571fqxfv61z4mwfjyw4jb2yqyqbsinwj2frwaxn";

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ma27 ];
  };
}
