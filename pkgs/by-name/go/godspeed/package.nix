{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
}:

buildGoModule (finalAttrs: {
  pname = "godspeed";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "redcode-labs";
    repo = "GodSpeed";
    tag = finalAttrs.version;
    hash = "sha256-y/mCfNWe5ShdxEz8IUQ8zUzgVkUy/+5lX6rcJ3r6KoI=";
  };

  vendorHash = "sha256-DCDAuKvov4tkf77nJNo9mQU/bAeQasp4VBQRtLX+U6c=";

  buildInputs = [ libpcap ];

  postFixup = ''
    mv $out/bin/GodSpeed $out/bin/${finalAttrs.pname}
  '';

  meta = {
    description = "Manager for reverse shells";
    homepage = "https://github.com/redcode-labs/GodSpeed";
    changelog = "https://github.com/redcode-labs/GodSpeed/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "godspeed";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
