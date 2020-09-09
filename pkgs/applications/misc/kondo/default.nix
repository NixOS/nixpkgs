{ stdenv, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "kondo";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "tbillington";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kl2zn6ir3w75ny25ksgxl93vlyb13gzx2795zyimqqnsrdpbbrf";
  };

  cargoSha256 = "1ax81a2828z3yla1psg5xi8ild65m6zcsvx48ncz902mpzqlj92b";

  meta = with stdenv.lib; {
    description = "Save disk space by cleaning unneeded files from software projects";
    homepage = "https://github.com/tbillington/kondo";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
  };
}
