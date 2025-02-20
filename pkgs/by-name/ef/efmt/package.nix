{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "efmt";
  version = "0.19.0";

  src = fetchFromGitHub {
    owner = "sile";
    repo = "efmt";
    rev = version;
    hash = "sha256-TvDIw9BNeqvsq13Ov9pBREj4d9FWtwfu7mzACc+qlZ4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-U9W9GIU4Ofqy2BW4onJSUPhyiFfTspj06Gzj6NeTwcI=";

  meta = {
    description = "Erlang code formatter";
    homepage = "https://github.com/sile/efmt";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ haruki7049 ];
    mainProgram = "efmt";
  };
}
