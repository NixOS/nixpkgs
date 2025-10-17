{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "french-numbers";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6mcqT0RZddHlzjyZzx0JGTfCRcQ2UQ3Qlmk0VVNzsnI=";
  };

  cargoHash = "sha256-HtgJsvl+BkvTapGxi7B/0QMEUolOw4gGndj4/9w7Z4Y=";

  cargoBuildFlags = [ "--features=cli" ];

  meta = with lib; {
    description = "Represent numbers in French language";
    homepage = "https://github.com/evenfurther/french-numbers";
    license = with licenses; [
      asl20 # or
      mit
    ];
    mainProgram = "french-numbers";
    maintainers = with maintainers; [ samueltardieu ];
  };
}
