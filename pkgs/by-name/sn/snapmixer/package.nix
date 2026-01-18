{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "snapmixer";
  version = "2.3.3";

  src = fetchFromGitHub {
    owner = "tremby";
    repo = "snapmixer";
    rev = "v${version}";
    hash = "sha256-xykkYt2WC4mIEynk3wbl+Z7zc2549k/uaTKdeZF9mkQ=";
  };

  cargoHash = "sha256-5jjp6huS3JN49PhlYiCMsQOh3nAVZ90OmaDpuWkv83U=";

  meta = with lib; {
    description = "Text-mode volume mixer for Snapcast";
    homepage = "https://github.com/tremby/snapmixer";
    license = licenses.mit;
    maintainers = with maintainers; [ tremby ];
    mainProgram = "snapmixer";
  };
}
