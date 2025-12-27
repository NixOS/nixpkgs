{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "lifecycled";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "buildkite";
    repo = "lifecycled";
    rev = "v${version}";
    sha256 = "sha256-GmzsvhJBUyKIUatCkPcWUp0Z0OldnUE5V7TnenCsPRk=";
  };

  vendorHash = "sha256-8IVw/vSrt7u9SgUGML8Q52UQ0XKUivr/TCxz/ncFe7s=";

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
      grahamc
    ];
  };
}
