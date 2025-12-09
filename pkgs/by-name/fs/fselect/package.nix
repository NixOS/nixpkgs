{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
  libiconv,
}:

rustPlatform.buildRustPackage rec {
  pname = "fselect";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-S9WlDpa9Qe3GVVC/L5KAyekH1NegdDttJ6HH5rwI6Dk=";
  };

  cargoHash = "sha256-q7FBKzVH2EtP2PjrU8bvQTrzvMZ0T+Cgk7o+lpyuTPc=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = lib.optional stdenv.hostPlatform.isDarwin libiconv;

  postInstall = ''
    installManPage docs/fselect.1
  '';

  meta = with lib; {
    description = "Find files with SQL-like queries";
    homepage = "https://github.com/jhspetersson/fselect";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
    mainProgram = "fselect";
  };
}
