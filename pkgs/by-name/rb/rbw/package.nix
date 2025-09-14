{
  lib,
  stdenv,
  rustPlatform,
  fetchzip,
  openssl,
  pkg-config,
  installShellFiles,
  bash,
  # rbw-fzf
  withFzf ? false,
  fzf,
  perl,

  # rbw-rofi
  withRofi ? false,
  rofi,
  xclip,

  # pass-import
  withPass ? false,
  pass,
}:

rustPlatform.buildRustPackage rec {
  pname = "rbw";
  version = "1.14.1";

  src = fetchzip {
    url = "https://git.tozt.net/rbw/snapshot/rbw-${version}.tar.gz";
    hash = "sha256-4wNDDMaz9zjNYahOZXARDbNdGKl0kS0pF3qQuM7fK4s=";
  };

  cargoHash = "sha256-H1DSP3Kyklv8ncn7zDP0njDlwB8Qh+h7mqWRAJcpWrE=";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [ bash ]; # for git-credential-rbw

  preConfigure = lib.optionalString stdenv.hostPlatform.isLinux ''
    export OPENSSL_INCLUDE_DIR="${openssl.dev}/include"
    export OPENSSL_LIB_DIR="${lib.getLib openssl}/lib"
  '';

  postInstall = ''
    install -Dm755 -t $out/bin bin/git-credential-rbw
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd rbw \
      --bash <($out/bin/rbw gen-completions bash) \
      --fish <($out/bin/rbw gen-completions fish) \
      --zsh <($out/bin/rbw gen-completions zsh)
  ''
  + lib.optionalString withFzf ''
    install -Dm755 -t $out/bin bin/rbw-fzf
    substituteInPlace $out/bin/rbw-fzf \
      --replace fzf ${fzf}/bin/fzf \
      --replace perl ${perl}/bin/perl
  ''
  + lib.optionalString withRofi ''
    install -Dm755 -t $out/bin bin/rbw-rofi
    substituteInPlace $out/bin/rbw-rofi \
      --replace rofi ${rofi}/bin/rofi \
      --replace xclip ${xclip}/bin/xclip
  ''
  + lib.optionalString withPass ''
    install -Dm755 -t $out/bin bin/pass-import
    substituteInPlace $out/bin/pass-import \
      --replace pass ${pass}/bin/pass
  '';

  meta = {
    description = "Unofficial command line client for Bitwarden";
    homepage = "https://crates.io/crates/rbw";
    changelog = "https://git.tozt.net/rbw/plain/CHANGELOG.md?id=${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      albakham
      jasonxue1
    ];
    mainProgram = "rbw";
  };
}
