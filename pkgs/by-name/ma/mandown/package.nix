{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "mandown";
  version = "1.1.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-a+1tm9YlBuroTtgCL0nTjASaPiJHif89pRH0CWw7RjM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ZyjoAvsqUyHgfEsG3+CvJatmBt0AJ2ga6HRJ8Y7her0=";

  meta = with lib; {
    description = "Markdown to groff (man page) converter";
    homepage = "https://gitlab.com/kornelski/mandown";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = [ ];
    mainProgram = "mandown";
  };
}
