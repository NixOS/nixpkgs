{
  lib,
  fetchFromSourcehut,
  rustPlatform,
  installShellFiles,
  scdoc,
  makeWrapper,

  # Script dependencies.
  fzf,
  wl-clipboard,
  xclip,
}:

rustPlatform.buildRustPackage rec {
  pname = "license-cli";
  version = "3.1.0";

  src = fetchFromSourcehut {
    owner = "~zethra";
    repo = "license";
    rev = version;
    hash = "sha256-OGS26mE5rjxlZOaBWhYc7C8aM3Lq2xX0f31LgckjJF8=";
  };

  cargoHash = "sha256-Jvg3XndPyQ9TYejJaO7GAI9RwLAOWB0uapA+6WIKAkI=";

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

  meta = with lib; {
    homepage = "https://git.sr.ht/~zethra/license";
    description = "Command-line tool to easily add license to your project";
    license = licenses.mpl20;
    mainProgram = "license";
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
