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
  version = "0.8.12";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-tvc6Ume9VoPsVFH0AdaQejyRG2M3VapG073a3aYDp7o=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-cLskCSeMLe1aryBVhnAQAVbdKiF0pVFRi9JqcUR1Q6I=";

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
    maintainers = with maintainers; [ Br1ght0ne ];
    mainProgram = "fselect";
  };
}
