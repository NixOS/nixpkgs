{ lib, stdenv, fetchFromGitHub, rustPlatform, cmake, pkg-config, openssl, oniguruma, CoreServices, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "zola";
  version = "unstable-2021-07-14";

  src = fetchFromGitHub {
    owner = "getzola";
    repo = pname;
    # unstable because the latest release fails to build
    rev = "312ffcb04c06c5f157b9fd2b944b858703238592";
    sha256 = "0i5zqs1gwxhvsynb540c3azfi4357igr4i5p0bi3h7ras2asas8w";
  };

  cargoSha256 = "0g5z0s837cfwzral2zz0avp0xywyaa3l1adxg520qrnga7z0kbh8";

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
    maintainers = with maintainers; [ dandellion dywedir _0x4A6F ];
    # set because of unstable-* version
    mainProgram = "zola";
  };
}
