{
  installShellFiles
, fetchFromGitHub
, lib
, micronucleus
, rustPlatform
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "elf2nucleus";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "kpcyrd";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FAIOtGfGow+0DrPPEBEfvaiinNZLQlGWKJ4DkMj63OA=";
  };

  cargoHash = "sha256-IeQnI6WTzxSI/VzoHtVukZtB1jX98wzLOT01NMLD5wQ=";

  nativeBuildInputs = [ installShellFiles ];

  buildInputs = [ micronucleus ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd elf2nucleus \
      --bash <($out/bin/elf2nucleus --completions bash) \
      --fish <($out/bin/elf2nucleus --completions fish) \
      --zsh <($out/bin/elf2nucleus --completions zsh)
  '';

  meta = with lib; {
    description = "Integrate micronucleus into the cargo buildsystem, flash an AVR firmware from an elf file";
    mainProgram = "elf2nucleus";
    homepage = "https://github.com/kpcyrd/elf2nucleus";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.marble ];
  };
}
