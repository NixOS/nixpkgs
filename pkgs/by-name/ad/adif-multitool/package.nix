{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "adif-multitool";
  version = "0.1.15";

  vendorHash = "sha256-oyFL021J/cU+N+mQ6kW3vju39P/uGM6U58uqE9sxIOE=";

  src = fetchFromGitHub {
    owner = "flwyd";
    repo = "adif-multitool";
    rev = "v${version}";
    hash = "sha256-zfJTEmjTomd2T/TkdNYZgIJBwx0PaByEkN/E2kgKHes=";
  };

  meta = {
    description = "Command-line program for working with ham logfiles.";
    homepage = "https://github.com/flwyd/adif-multitool";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mafo ];
    mainProgram = "adifmt";
  };
}
