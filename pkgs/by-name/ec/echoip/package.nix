{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  nixosTests,
  nix-update-script,
}:

buildGoModule {
  pname = "echoip";
  version = "0-unstable-2026-02-14";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "0405a55f7d0007c72aaf88e449b8416a62f16772";
    hash = "sha256-oMxbFyFQ1VYXgUU3wkDrfmIku8uigvF3bJInGNQAZkc=";
  };

  vendorHash = "sha256-gNXu1yfvJnviPDeG0oNJ9MD5R93rjEV/n8hrADi8ZnM=";

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    install -D html/* -t $out/share/echoip/html
    wrapProgram $out/bin/echoip \
      --add-flags "-t $out/share/echoip/html"
  '';

  passthru = {
    tests = { inherit (nixosTests) echoip; };
    updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };
  };

  meta = {
    description = "IP address lookup service";
    homepage = "https://github.com/mpolden/echoip";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      rvolosatovs
      SuperSandro2000
      defelo
    ];
    mainProgram = "echoip";
  };
}
