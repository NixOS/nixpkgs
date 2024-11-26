{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rhack";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "nakabonne";
    repo = pname;
    rev = "v${version}";
    sha256 = "088ynf65szaa86pxwwasn3wwi00z5pn7i8w9gh5dyn983z4d8237";
  };

  cargoHash = "sha256-HmBh2qbO/HuNPfHKifq41IB5ResnGka2iaAsnwppm9s=";

  meta = with lib; {
    description = "Temporary edit external crates that your project depends on";
    mainProgram = "rhack";
    homepage = "https://github.com/nakabonne/rhack";
    license = licenses.bsd3;
    maintainers = with maintainers; [ figsoda ];
  };
}
