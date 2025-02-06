{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "kamp";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "vbauerster";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-JZe8z6OYJ+I0+dcq+sCoQPzlz6eB4z98jWj8MDXdODY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-QGTa2emaz3Nzoe3UuvbKCoopOoKD29RSWPG5wvPe+RE=";

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
