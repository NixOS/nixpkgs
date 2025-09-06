{
  buildGoModule,
  fetchFromGitHub,
  lib,
  iptables,
  makeWrapper,
}:
buildGoModule rec {
  pname = "guardian";
  version = "46f1db7"; # Rolling release
  meta = {
    description = "A simple single-host OCI container manager.";
    homepage = "https://github.com/cloudfoundry/guardian";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lenianiva
    ];
    mainProgram = "gdn";
    platforms = lib.platforms.linux;
  };

  src = fetchFromGitHub {
    owner = "cloudfoundry";
    repo = "guardian";
    rev = "46f1db7abef6721db5aa3a65632646b9adcc1b49";
    hash = "sha256-/H4fv70ezoKKrj0vc396cT/b02gM3dsxswD5nlxjTRM=";
  };

  vendorHash = null;
  subPackages = [ "cmd/gdn" ];
  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    wrapProgram $out/bin/gdn \
      --prefix PATH : ${lib.makeBinPath [ iptables ]}
  '';
}
