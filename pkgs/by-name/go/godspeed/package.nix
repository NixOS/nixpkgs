{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule rec {
  pname = "godspeed";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GodSpeed";
    tag = version;
    hash = "sha256-y/mCfNWe5ShdxEz8IUQ8zUzgVkUy/+5lX6rcJ3r6KoI=";
  };

  vendorHash = "sha256-DCDAuKvov4tkf77nJNo9mQU/bAeQasp4VBQRtLX+U6c=";

  buildInputs = [ libpcap ];

  postFixup = ''
    mv $out/bin/GodSpeed $out/bin/${pname}
  '';

  meta = {
    description = "Manager for reverse shells";
    homepage = "https://github.com/redcode-labs/GodSpeed";
    changelog = "https://github.com/redcode-labs/GodSpeed/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    teams = [ lib.teams.redcodelabs ];
    mainProgram = "godspeed";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
