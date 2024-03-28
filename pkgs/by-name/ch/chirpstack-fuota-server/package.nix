{ lib
, buildGoModule
, fetchFromGitHub
}: buildGoModule rec {
  pname = "chirpstack-fuota-server";
  name = pname;

  src = fetchFromGitHub {
    owner = "chirpstack";
    repo = "chirpstack-fuota-server";
    rev = "28a40c2a13af08f47d68964055236264cbc8153e";
    hash = "sha256-LAYS9rFJkRkFo1X0HeGCb2lmEIMl+KHiEHs3O66KvHY=";
  };

  vendorHash = "sha256-dTmHkauFelqMo5MpB/TyK5yVax5d4/+g9twjmsRG3e0=";

  ldflags = [
    "-s"
    "-w"
    # "-X main.version=${version}"
  ];

  doCheck = false;

  meta = with lib; {
    description = "FUOTA server which can be used together with ChirpStack Application Server";
    homepage = "https://www.chirpstack.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ stv0g ];
    platforms = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];
    mainProgram = "chirpstack-fuota-server";
  };
}
