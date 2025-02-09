{
  stdenv,
  fetchFromGitHub,
  lib,
  makeWrapper,
  rustPlatform,
  wget,
  libiconv,
  withFzf ? true,
  fzf,
}:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.23.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    rev = "v${version}";
    sha256 = "sha256-pqBTrHBvsuosyQqCnSiI3+pOe2J6XeIQ8dai+kTVFjc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KbtP7zJJDBRy0ZSka8/4G0ftXB8r7//hgUzgT6E7fP8=";

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  postInstall = ''
    wrapProgram $out/bin/navi \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath ([ wget ] ++ lib.optionals withFzf [ fzf ])}
  '';

  checkFlags = [
    # error: Found argument '--test-threads' which wasn't expected, or isn't valid in this context
    "--skip=test_parse_variable_line"
  ];

  meta = with lib; {
    description = "Interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "navi";
    maintainers = with maintainers; [ cust0dian ];
  };
}
