{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.10.4";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-tAYFuxB8LSyFHraAQxCj8Q09mS/9RYcinVm5whpRh04=";
  };

  vendorSha256 = "sha256-IFxKczPrqCM9NOoOJayfbrsJIMf3eoI9zXSFns0/i8o=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd gmailctl \
      --bash <($out/bin/gmailctl completion bash) \
      --fish <($out/bin/gmailctl completion fish) \
      --zsh <($out/bin/gmailctl completion zsh)
  '';

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar SuperSandro2000 ];
  };
}
