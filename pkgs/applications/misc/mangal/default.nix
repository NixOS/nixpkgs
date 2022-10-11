{ lib, stdenv, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "mangal";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "metafates";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1fWy7riInrbReQ0sQ1TF8GhqWQG0KXk1JzhmxlSuvmk=";
  };

  proxyVendor = true;
  vendorSha256 = "sha256-+HDuGSZinotUtCqffrmFkjHegxdArSJMWwnUG/tnLRc=";

  ldflags = [ "-s" "-w" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.hostPlatform == stdenv.buildPlatform) ''
    # Mangal creates a config file in the folder ~/.config/mangal and fails if not possible
    export MANGAL_CONFIG_PATH=`mktemp -d`
    installShellCompletion --cmd mangal \
      --bash <($out/bin/mangal completion bash) \
      --zsh <($out/bin/mangal completion zsh) \
      --fish <($out/bin/mangal completion fish)
  '';

  doCheck = false; # test fail because of sandbox

  meta = with lib; {
    description =
      "A fancy CLI app written in Go which scrapes, downloads and packs manga into different formats";
    homepage = "https://github.com/metafates/mangal";
    license = licenses.mit;
    maintainers = [ maintainers.bertof ];
  };
}
