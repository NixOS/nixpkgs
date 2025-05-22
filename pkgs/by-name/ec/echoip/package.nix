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
  version = "0-unstable-2023-05-21";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "d84665c26cf7df612061e9c35abe325ba9d86b8d";
    hash = "sha256-7qc1NZu0hC1np/EKf5fU5Cnd7ikC1+tIrYOXhxK/++Y=";
  };

  vendorHash = "sha256-lXYpkeGpBK+WGHqyLxJz7kS3t7a55q55QQLTqtxzroc=";

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
