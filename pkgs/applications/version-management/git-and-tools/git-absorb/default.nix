{ stdenv, fetchFromGitHub, rustPlatform, installShellFiles, libiconv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "git-absorb";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner  = "tummychow";
    repo   = pname;
    rev    = "refs/tags/${version}";
    sha256 = "1da6h9hf98dnnqw9jpnj1x2gr7psmsa8219gpamylfg1ifk28rkr";
  };

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = stdenv.lib.optionals stdenv.isDarwin [ libiconv Security ];

  cargoSha256 = "1ba43m5ndyj4hwwfyg0c2hwv3ad7kzhrr7cvymsgaj2dxl7bif4w";

  postInstall = ''
    installManPage Documentation/git-absorb.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/tummychow/git-absorb";
    description = "git commit --fixup, but automatic";
    license = [ licenses.bsd3 ];
    maintainers = [ maintainers.marsam ];
  };
}
