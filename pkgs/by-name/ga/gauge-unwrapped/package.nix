{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gauge";
  version = "1.6.38";

  patches = [
    # adds a check which adds an error message when trying to
    # install plugins imperatively when using the wrapper
    ./nix-check.patch
  ];

  src = fetchFromGitHub {
    owner = "getgauge";
    repo = "gauge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-maU/LKLyXTcLp+oAA/3mJakM/guoysCSYpgGf29tYb4=";
  };

  vendorHash = "sha256-uU5pX81/va0RSpEn1jgWZGbuz5uA3DqwM4/yf3BvRbM=";

  excludedPackages = [
    "build"
    "man"
  ];

  meta = {
    description = "Light weight cross-platform test automation";
    mainProgram = "gauge";
    homepage = "https://gauge.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
    ];
  };
})
