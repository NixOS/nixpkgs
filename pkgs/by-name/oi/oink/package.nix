{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "oink";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "rlado";
    repo = "oink";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e8FtjORTTIDnDANk8sWH8kmS35wyndDd6F7Vhepskb8=";
  };

  vendorHash = null;

  postInstall = ''
    mv $out/bin/src $out/bin/oink
  '';

  meta = {
    description = "Dynamic DNS client for Porkbun";
    homepage = "https://github.com/rlado/oink";
    license = lib.licenses.mit;
    mainProgram = "oink";
    maintainers = with lib.maintainers; [
      jtbx
      pmw
    ];
  };
})
