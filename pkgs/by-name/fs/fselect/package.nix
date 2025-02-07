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
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-gEiKv1YbNNWexNfzUULbe0fT0ueJ9TJojhBHp31i6OY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/FBEv1jDlYrx06Ia/lF3Vcjnl5nWg0aEQefY67kh9Bw=";

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
