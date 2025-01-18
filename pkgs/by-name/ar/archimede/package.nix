{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

let
  version = "0.0.2";
in
buildGoModule {
  pname = "archimede";
  inherit version;

  src = fetchFromGitHub {
    owner = "gennaro-tedesco";
    repo = "archimede";
    tag = "v${version}";
    hash = "sha256-7P7PtzYlcNYG2+KW9zvcaRlTW+vHw8jeLD2dEQXmrzc=";
  };

  vendorHash = "sha256-F74TVp6+UdV31YVYYHWtdIzpbbiYM2I8csGobesFN2g=";

  meta = with lib; {
    homepage = "https://github.com/gennaro-tedesco/archimede";
    description = "Unobtrusive directory information fetcher";
    license = licenses.asl20;
    mainProgram = "archimede";
    maintainers = [ maintainers.anugrahn1 ];
  };
}
