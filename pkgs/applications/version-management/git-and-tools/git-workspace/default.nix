{ stdenv
, fetchFromGitHub
, rustPlatform
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "git-workspace";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "orf";
    repo = pname;
    rev = "v${version}";
    sha256 = "01qxm00c5wqpy1clrvjr44v7cg4nqawaf5a6qnvvgswvis4kakzr";
  };

  cargoSha256 = "16rkmk888alfvq8nsggi26vck1c7ya0fa5j7gv219g5py4gw2n34";

  verifyCargoDeps = true;

  buildInputs = with stdenv; lib.optional isDarwin Security;

  meta = with stdenv.lib; {
    description = "Sync personal and work git repositories from multiple providers";
    homepage = "https://github.com/orf/git-workspace";
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ misuzu ];
  };
}
