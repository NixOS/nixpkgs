{ lib
, buildGoModule
, fetchFromGitHub
}:
buildGoModule rec {
  pname = "glider";
  version = "0.16.3";

  src = fetchFromGitHub {
    owner = "nadoo";
    repo = "glider";
    rev = "v${version}";
    hash = "sha256-nM6jKFqyaxZbn0wyEt0xy9uTu9JyLRfGTNsGPTQOXQw=";
  };

  vendorHash = "sha256-PGIBBop/waZDeQvW7iSi/AzLye/4t7nNXjX8zJsS2eo=";

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    substituteInPlace systemd/glider@.service \
      --replace-fail "/usr/bin/glider" "$out/bin/glider"
    install -Dm444 -t "$out/lib/systemd/system/" systemd/glider@.service
  '';

  meta = with lib; {
    homepage = "https://github.com/nadoo/glider";
    description = "Forward proxy with multiple protocols support";
    license = licenses.gpl3Only;
    mainProgram = "glider";
    maintainers = with maintainers; [ oluceps ];
    platforms = platforms.linux;
  };
}
