{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "eva";
  version = "0.3.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-eX2d9h6zNbheS68j3lyhJW05JZmQN2I2MdcmiZB8Mec=";
  };

  cargoHash = "sha256-7vhhm2qAaSwBjbYfDER9bnC3OOOun4brn7Ft4mO6jfI=";

  meta = with lib; {
    description = "Calculator REPL, similar to bc";
    homepage = "https://github.com/oppiliappan/eva";
    license = licenses.mit;
    maintainers = with maintainers; [
      ma27
      figsoda
    ];
    mainProgram = "eva";
  };
}
