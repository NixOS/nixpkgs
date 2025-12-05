{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  installShellFiles,
  scdoc,
  makeWrapper,
  nix-update-script,

  # Script dependencies.
  fzf,
  wl-clipboard,
  xclip,
}:

rustPlatform.buildRustPackage rec {
  pname = "license-cli";
  version = "3.2.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "license";
    rev = version;
    hash = "sha256-jXhWktTwqVXrCFUVX8qnVoS7n4KkR9S6c/G8QpyU3VA=";
  };

  cargoHash = "sha256-6P7QcshuZp3b+d0IYW8+M2TsBfvzGjVwkqZ1Gqa5SuI=";

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];

  preInstall = ''
    ${scdoc}/bin/scdoc < doc/license.scd > license.1
  '';

  postInstall = ''
    installShellCompletion completions/license.{bash,fish}
    installShellCompletion --zsh completions/_license
    installManPage ./license.1

    install -Dm0755 ./scripts/set-license -t $out/bin
    wrapProgram $out/bin/set-license \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${lib.makeBinPath [ fzf ]}

    install -Dm0755 ./scripts/copy-header -t $out/bin
    wrapProgram $out/bin/copy-header \
      --prefix PATH : "$out/bin" \
      --prefix PATH : ${
        lib.makeBinPath [
          wl-clipboard
          xclip
        ]
      }
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://git.sr.ht/~zethra/license";
    description = "Command-line tool to easily add license to your project";
    license = licenses.mpl20;
    mainProgram = "license";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
