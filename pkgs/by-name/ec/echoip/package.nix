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
  version = "0-unstable-2026-02-17";

  src = fetchFromGitHub {
    owner = "mpolden";
    repo = "echoip";
    rev = "c3394af786b05879fc1219eb0d33b82b8dd806b0";
    hash = "sha256-L1cLLEhPGtLYaJcbc26YPuUCZh8pmbceIWQ5iIEh4i4=";
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
