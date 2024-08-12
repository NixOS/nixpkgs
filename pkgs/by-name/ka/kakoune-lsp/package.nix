{ stdenv, lib, fetchFromGitHub, rustPlatform, perl, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "17.1.1";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-XBH2pMDiHJNXrx90Lt0IcsbMFUM+X7GAHgiHpdlIdR4=";
  };

  cargoHash = "sha256-Yi+T+9E3Wvce4kDLsRgZ07RAGLrq7dkinKpvvGeLeS0=";

  buildInputs = [ perl ] ++ lib.optionals stdenv.isDarwin [ CoreServices Security SystemConfiguration ];

  patches = [
    ./Use-full-Perl-path.patch
  ];

  postPatch = ''
    substituteInPlace rc/lsp.kak \
      --subst-var-by perlPath ${lib.getBin perl}
  '';

  meta = with lib; {
    description = "Kakoune Language Server Protocol Client";
    homepage = "https://github.com/kakoune-lsp/kakoune-lsp";
    license = with licenses; [ unlicense /* or */ mit ];
    maintainers = with maintainers; [ philiptaron spacekookie poweredbypie ];
    mainProgram = "kak-lsp";
  };
}
