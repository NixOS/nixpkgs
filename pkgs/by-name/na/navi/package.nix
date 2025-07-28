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
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "navi";
  version = "2.24.0";

  src = fetchFromGitHub {
    owner = "denisidoro";
    repo = "navi";
    tag = "v${version}";
    hash = "sha256-zvqxVu147u/m/4B3fhbuQ46txGMrlgQv9d4GGiR8SoQ=";
  };

  cargoHash = "sha256-tQCm8KMVWo6KiKVOMDitHtDXwYGM7INXcT+7fEEiIiI=";

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Interactive cheatsheet tool for the command-line and application launchers";
    homepage = "https://github.com/denisidoro/navi";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "navi";
    maintainers = with lib.maintainers; [ cust0dian ];
  };
}
