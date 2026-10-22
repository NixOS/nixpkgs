{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "lifecycled";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "lifecycled";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WB8DE6rKbBxOi/xLvn410IbpY/3MSWLzNBZIth0EEhw=";
  };

  vendorHash = "sha256-OJodZspW02qHvLg/eZe0PbTPAn/PsA4YPgzszdu09+w=";

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
