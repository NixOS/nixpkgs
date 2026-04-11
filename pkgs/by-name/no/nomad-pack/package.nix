{
  lib,
  fetchFromGitHub,
  buildGoModule,
}:

buildGoModule (finalAttrs: {
  pname = "nomad-pack";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-pack";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-hXMhUg9as2ZwlRtCahI5Og9WOdgkNZ5nS6vtuSTeLdw=";
  };

  vendorHash = "sha256-jCgH9uHjUkLDDrOWgVofzriwx5eXh9+YNx0toGGu9T0=";

  # skip running go tests as they require network access
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nomad-pack --version
    runHook postInstallCheck
  '';

  meta = {
    homepage = "https://github.com/hashicorp/nomad-pack";
    changelog = "https://github.com/hashicorp/nomad-pack/blob/main/CHANGELOG.md";
    description = "Nomad Pack is a templating and packaging tool used with HashiCorp Nomad";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ techknowlogick ];
  };

})
