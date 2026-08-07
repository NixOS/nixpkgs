{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "imgcrypt";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "imgcrypt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xHL+vxjGkjkDCEHMVOQsT6uokZq50iFAqGyDj6dDuG4=";
  };

  modRoot = "cmd";

  vendorHash = "sha256-tTRYEvqhQm1XpSvXDDXEx5piZYOxAtmcjf2dLL9fGck=";

  ldflags = [
    "-X github.com/containerd/containerd/version.Version=${finalAttrs.version}"
  ];

  subPackages = [
    "ctd-decoder"
    "ctr"
  ];

  postFixup = ''
    mv $out/bin/ctr $out/bin/ctr-enc
  '';

  meta = {
    description = "Image encryption library and command line tool";
    homepage = "https://github.com/containerd/imgcrypt";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mikroskeem ];
  };
})
