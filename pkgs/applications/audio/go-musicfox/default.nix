{ lib
, fetchFromGitHub
, buildGoModule
, clangStdenv
, pkg-config
, alsa-lib
, flac
}:

# gcc only supports objc on darwin
buildGoModule.override { stdenv = clangStdenv; } rec {
  pname = "go-musicfox";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "anhoder";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iinEo+HrcNM3gx1iUqe1duRd45PrYgVybRt9NKphwuY=";
  };

  deleteVendor = true;

  vendorHash = "sha256-DbdAEvcspTYMYMvc5IBEUtQAJMW8JZpNi0UA/DvzGFo=";

  subPackages = [ "cmd/musicfox.go" ];

  ldflags = [
    "-s"
    "-w"
    "-X go-musicfox/pkg/constants.AppVersion=${version}"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    flac
  ];

  meta = with lib; {
    description = "Terminal netease cloud music client written in Go";
    homepage = "https://github.com/anhoder/go-musicfox";
    license = licenses.mit;
    mainProgram = "musicfox";
    maintainers = with maintainers; [ zendo ];
  };
}
