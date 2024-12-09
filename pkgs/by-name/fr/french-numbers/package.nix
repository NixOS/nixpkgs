{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "french-numbers";
  version = "1.2.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-6mcqT0RZddHlzjyZzx0JGTfCRcQ2UQ3Qlmk0VVNzsnI=";
  };

  cargoHash = "sha256-YmG+4837j7g3iK/nsP2P+WVcOqaPxKiS0jhcxkpEGXw=";

  cargoBuildFlags = [ "--features=cli" ];

  meta = with lib; {
    description = "Represent numbers in French language";
    homepage = "https://github.com/evenfurther/french-numbers";
    license = with licenses; [ asl20 /* or */ mit ];
    mainProgram = "french-numbers";
    maintainers = with maintainers; [ samueltardieu ];
  };
}
