{ stdenv, fetchFromGitHub, lib, makeWrapper, rustPlatform, wget, libiconv, withFzf ? true, fzf }:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.18.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "sha256-JG0MZrvpx+cAFcZJK05GUI10PG53UmxjJjveAZA7k/M=";
  };

  cargoSha256 = "sha256-S2DBzeir6+JS1jfVxCQ68v4Rl7UBpghbtE+wdu341xw=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath([ wget ] ++ lib.optionals withFzf [ fzf ])}
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
