{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "lmp";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "0xInfection";
    repo = "LogMePwn";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-VL/Hp7YaXNcV9JPb3kgRHcdhJJ5p3KHUf3hHbT3gKVk=";
  };

  vendorHash = "sha256-3NTaJ/Y3Tc6UGLfYTKjZxAAI43GJyZQ5wQVYbnXHSYc=";

  meta = {
    description = "Scanning and validation toolkit for the Log4J vulnerability";
    homepage = "https://github.com/0xInfection/LogMePwn";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "lmp";
  };
})
