{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    rev = "v${version}";
    sha256 = "1cvvxiginwf1rldijzwk9gh63qc0ls5d7j3j8ri7yhk21pz9f6bi";
  };

  cargoSha256 = "1hg8j9a8c6c3ap24jd96y07rlp4f0s2mkyx5034nlnkm3lj4q42n";

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
