{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "nomad-driver-podman";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "hashicorp";
    repo = "nomad-driver-podman";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-ZUZr992bK4e08bh6peYN5B35N7PEVTOSySUWwQ132iA=";
  };

  vendorHash = "sha256-AmG4YQNW20wRfNHl9l8RkByrTIfmAjBxnWvndf1jqYU=";

  subPackages = [ "." ];

  # some tests require a running podman service
  doCheck = false;

  meta = {
    homepage = "https://www.github.com/hashicorp/nomad-driver-podman";
    description = "Podman task driver for Nomad";
    mainProgram = "nomad-driver-podman";
    platforms = lib.platforms.linux;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
