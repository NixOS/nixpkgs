{ stdenv, fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "sha256-qcfSGV/+FkyWGAApekRZHWGmeB9gIURt11DKn7lEh+o=";
  };

  cargoSha256 = "sha256-HpGzDZMIzO0lpussmm+kJNOU7zghcYrQWZo3WZ5FOmA=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ fzf wget ]}
  '';

  meta = with lib; {
    description = "An interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cust0dian ];
  };
}
