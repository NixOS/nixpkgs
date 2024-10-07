{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kamp";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "vbauerster";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9cakFhA9niMZ0jD0ilgCUztk4uL6wDp6zfHUJY/yLYw=";
  };

  cargoHash = "sha256-BnVV0UnXEebq1kbQvv8PkmntLK0BwrOcMxxIODpZrxc=";

  postInstall = ''
    install scripts/* -Dt $out/bin
  '';

  meta = {
    description = "Tool to control Kakoune editor from the command line";
    homepage = "https://github.com/vbauerster/kamp";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ erikeah ];
    mainProgram = "kamp";
    platforms = lib.platforms.linux;
  };
}
