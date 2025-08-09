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
  version = "0.8.11";

  src = fetchFromGitHub {
    owner = "jhspetersson";
    repo = "fselect";
    rev = version;
    sha256 = "sha256-S7SFcOhFl5dVgUl2qlsE/Bizq8v0NPKPqBggzPGoOu8=";
  };

  cargoHash = "sha256-r6GKJGJThaaawHcL+IL29Vy/NXmA75eswEBWDS/zs1g=";

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
