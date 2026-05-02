{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "fscan";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "shadow1ng";
    repo = "fscan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wvtabfLoPKCmoWL083z1c3g0iOQRtTtgwZxozIaeiw0=";
  };

  vendorHash = "sha256-hDe5IMvOUeAvst8mCWNMCRWcPyJ9Ufomv1Zpjxgcj/0=";

  meta = {
    description = "Intranet comprehensive scanning tool";
    homepage = "https://github.com/shadow1ng/fscan";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Misaka13514 ];
    mainProgram = "fscan";
  };
})
