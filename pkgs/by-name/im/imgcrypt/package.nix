{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "imgcrypt";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "imgcrypt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-nr5M+xbu7TY9zZEBXmIAErIUZuOk0rxMIVrPdFMrg8s=";
  };

  modRoot = "cmd";

  vendorHash = "sha256-PuubaNqPHSVWqavV5oTNDn6ZiQDGoGnkAN9HS3JAcdA=";

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
