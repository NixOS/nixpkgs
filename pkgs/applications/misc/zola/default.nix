{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "unstable-2021-07-10";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    # unstable because the latest release fails to build
    rev = "8c3ce7d7fbc0d585d4cbf27598ac7dfe5acd96f1";
    sha256 = "sha256-Tw3u96ZPb0yUXvtJ+rna6nnb0a+KfTEiR/PPEadFxDA=";
  };

  cargoSha256 = "sha256-mOO39LK7lQ5IxwMgfJpNwX/H5MZ3qKqfeDmnY8zXOx4=";

  nativeBuildInputs = [ cmake pkg-config installShellFiles];
  buildInputs = [ openssl oniguruma ]
    ++ lib.optional stdenv.isDarwin CoreServices;

  RUSTONIG_SYSTEM_LIBONIG = true;

  postInstall = ''
    installShellCompletion --cmd zola \
      --fish completions/zola.fish \
      --zsh completions/_zola \
      --bash completions/zola.bash
  '';

  meta = with lib; {
    description = "A fast static site generator with everything built-in";
    homepage = "https://www.getzola.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ dywedir _0x4A6F ];
    # set because of unstable-* version
    mainProgram = "zola";
  };
}
