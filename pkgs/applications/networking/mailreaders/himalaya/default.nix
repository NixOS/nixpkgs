{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, enableCompletions ? stdenv.hostPlatform == stdenv.buildPlatform
, installShellFiles
, pkg-config
, Security
, libiconv
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "himalaya";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "soywod";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BZTecYNY8gbGe+r80QWi7FkC56dww9rrtwLfi9ya1mQ=";
  };

  cargoSha256 = "sha256-2xkKJqp7uf0gh8g2zzDjSl8foTvPj6MVHfDuSr914HU=";

  nativeBuildInputs = lib.optionals enableCompletions [ installShellFiles ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ pkg-config ];

  buildInputs =
    if stdenv.hostPlatform.isDarwin then [
      Security
      libiconv
    ] else [
      openssl
    ];

  postInstall = lib.optionalString enableCompletions ''
    # Install shell function
    installShellCompletion --cmd himalaya \
      --bash <($out/bin/himalaya completion bash) \
      --fish <($out/bin/himalaya completion fish) \
      --zsh <($out/bin/himalaya completion zsh)
  '';

  meta = with lib; {
    description = "CLI email client written in Rust";
    homepage = "https://github.com/soywod/himalaya";
    changelog = "https://github.com/soywod/himalaya/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ yanganto ];
  };
}
