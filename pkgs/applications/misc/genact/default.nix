{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-iPDIbfbRNhgmTQHw9gNczXTcUaJ0dQpBDHg5ZOQQJ4M=";
  };

  cargoHash = "sha256-Hg8Xlcx0j70Z8IwlJPCwm+qhurXjtKGLI3ZUCeHL1KY=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/genact --print-manpage > genact.1
    installManPage genact.1

    installShellCompletion --cmd genact \
      --bash <($out/bin/genact --print-completions bash) \
      --fish <($out/bin/genact --print-completions fish) \
      --zsh <($out/bin/genact --print-completions zsh)
  '';

  meta = with lib; {
    description = "A nonsense activity generator";
    homepage = "https://github.com/svenstaro/genact";
    changelog = "https://github.com/svenstaro/genact/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
