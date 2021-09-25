{ stdenv, fetchFromGitHub, fzf, lib, makeWrapper, rustPlatform, wget, libiconv }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.17.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "sha256-WH8FfQ7cD4aFUi9iE0tR/B+5oWy8tMVmMLxusDwXF7w=";
  };

  cargoSha256 = "sha256-TH9DNCoUVqH5g05Z4Vdv7F8CCLnaYezupI5FeJhYTaQ=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ fzf wget ]}
  '';

  checkFlags = [
    # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
    "--skip=test_parse_variable_line"
   ];

  meta = with lib; {
    description = "An interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cust0dian ];
  };
}
