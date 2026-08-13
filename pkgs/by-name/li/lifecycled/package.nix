{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lifecycled";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "lifecycled";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-zskN2T0+1xZPjppggeGpPFuQ8/AgPNyN77F33rDoghc=";
  };

  vendorHash = "sha256-q5wYKSLHRzL+UGn29kr8+mUupOPR1zohTscbzjMRCS0=";

  postInstall = ''
    mkdir -p $out/lib/systemd/system
    substitute init/systemd/lifecycled.unit $out/lib/systemd/system/lifecycled.service \
      --replace /usr/bin/lifecycled $out/bin/lifecycled
  '';

  meta = {
    description = "Daemon for responding to AWS AutoScaling Lifecycle Hooks";
    homepage = "https://github.com/buildkite/lifecycled/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cole-h
    ];
  };
})
