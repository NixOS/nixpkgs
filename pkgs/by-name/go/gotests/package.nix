{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gotests";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "cweill";
    repo = "gotests";
    rev = "v${version}";
    sha256 = "sha256-lx8gbVm4s4kmm252khoSukrlj5USQS+StGuJ+419QZw=";
  };

  vendorHash = "sha256-/dP8uA1yWBrtmFNHUvcicPhA2qr5R2v1uSwYi+ciypg=";

  # tests are broken in nix environment
  doCheck = false;

  meta = with lib; {
    description = "Generate Go tests from your source code";
    mainProgram = "gotests";
    homepage = "https://github.com/cweill/gotests";
    maintainers = with maintainers; [ vdemeester ];
    license = licenses.asl20;
  };
}
