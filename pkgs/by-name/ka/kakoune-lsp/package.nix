{ stdenv, lib, fetchFromGitHub, rustPlatform, perl, CoreServices, Security, SystemConfiguration }:

rustPlatform.buildRustPackage rec {
  pname = "kakoune-lsp";
  version = "16.0.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d4Tc6iYp20uOKMd+T2LhWgXWZzvzq1E+VWqjhhiIiHE=";
  };

  cargoHash = "sha256-kV8d0PwIWS6gyfCtv70iv8MrL91ZOZbwYznhc3lUw0U=";

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
    maintainers = with maintainers; [ spacekookie poweredbypie ];
    mainProgram = "kak-lsp";
  };
}
