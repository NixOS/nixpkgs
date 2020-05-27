{ lib, fetchFromGitHub, rustPlatform, llvmPackages, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "delta";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "dandavison";
    repo = pname;
    rev = version;
    sha256 = "1b5ap468d0gvgwkx6wqxvayzda2xw95lymd0kl38nq1fc0ica6hk";
  };

  LLVM_CONFIG_PATH = "${llvmPackages.llvm}/bin/llvm-config";
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoSha256 = "07mjl751r9d88fnmnan0ip0m3vxqf51vq2y7k3g3yywcgasj9jgr";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --bash --name delta.bash completion/bash/completion.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/dandavison/delta";
    description = "A syntax-highlighting pager for git";
    changelog = "https://github.com/dandavison/delta/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ma27 ];
  };
}
