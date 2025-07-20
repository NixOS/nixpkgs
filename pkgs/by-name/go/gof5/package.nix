{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule rec {
  pname = "gof5";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "kayrus";
    repo = "gof5";
    rev = "v${version}";
    sha256 = "sha256-tvahwd/UBKGYOXIgGwN98P4udcf6Bqrsy9mZ/3YVkvM=";
  };

  vendorHash = "sha256-kTdAjNYp/qQnUhHaCD6Hn1MlMpUsWaRxTSHWSUf6Uz8=";

  # The tests are broken and apparently you need to uncomment some lines in the
  # code in order for it to work.
  # See: https://github.com/kayrus/gof5/blob/674485bdf5a0eb2ab57879a32a2cb4bab8d5d44c/pkg/client/http.go#L172-L174
  doCheck = false;

  meta = with lib; {
    description = "Open Source F5 BIG-IP VPN client";
    homepage = "https://github.com/kayrus/gof5";
    license = licenses.asl20;
    maintainers = with maintainers; [ leixb ];
    mainProgram = "gof5";
  };
}
