{ lib, rustPlatform, fetchFromGitHub, installShellFiles }:

rustPlatform.buildRustPackage rec {
  pname = "genact";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Rn9kJWutWKPj9cLu2ZJKITmC+I8/ikhCAoIp00Yg6ZA=";
  };

  cargoHash = "sha256-kmXtwS5pCLEq5dbNHtWYGzDKjOUlVlr5xippVd2wl8k=";

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
    mainProgram = "genact";
  };
}
