{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "1mvin6pfqhsfhaifivbdi6qcn0dsa98w83m1n51q807gh4l1k2yj";
  };

  cargoSha256 = "02bk399c7x15a5rkaz7ik65yihkfbjn1q46gx7l8hycqq7xb0xmg";

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
    changelog = "https://github.com/getzola/zola/raw/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
    # set because of unstable-* version
    mainProgram = "zola";
  };
}
