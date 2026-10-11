{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  pkgs,
}:

buildGoModule {
  pname = "m1-terraform-provider-helper";
  version = "0.9.0";

  nativeBuildInputs = [
    pkgs.curl
    pkgs.cacert
    pkgs.git
  ];
  src = fetchFromGitHub {
    owner = "kreuzwerker";
    repo = "m1-terraform-provider-helper";
    rev = "0.9.0";
    sha256 = "0plng7kz768v1km8mxw7jzsrvpxfzg991lrwwndpkgnyk2m28cnv";
  };

  # Only build from the root package
  subPackages = [ "." ];

  vendorHash = "sha256-+UzPs1kiapYy5WMwx6EkQBlBs3DpWhzaQcYqdlzH94U=";

  passthru.updateScript = nix-update-script { };

  # Use custom build command from Makefile
  buildPhase = ''
    make build-release VERSION=$version
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp dist/release/m1-terraform-provider-helper $out/bin/
  '';

  doCheck = true;
  checkPhase = ''
    make test-functional TEST_TIMEOUT=2m
  '';
  meta = {
    description = "A CLI to manage the installation and compilation of Terraform providers for an ARM-based Mac.";
    longDescription = ''
      Helper tool for local building of older terraform providers that are not available for Apple silicon.
      Requires `go` for building and `git` for checking out providers.
    '';
    homepage = "https://github.com/kreuzwerker/m1-terraform-provider-helper";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cfl4g ];
    platforms = lib.platforms.darwin;
    changelog = "https://github.com/kreuzwerker/m0-terraform-provider-helper/releases/tag/$version";
  };
}
