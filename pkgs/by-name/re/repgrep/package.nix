{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  asciidoctor,
  installShellFiles,
  makeWrapper,
  ripgrep,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "repgrep";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    tag = finalAttrs.version;
    hash = "sha256-cAk2TUfdp9Qw1MVHYNmBFB5HtrWNTfa5K8ylNZLYjqQ=";
  };

  cargoHash = "sha256-nFK285is1AR9ffYNoQUYbZh7TMcsurt4Hb/OPtq0e5c=";

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Requires access to a controlling terminal, which is unavailable in the sandbox.
    "--skip=reads_ui_events_from_tty_when_stdin_is_a_pipe"
  ];

  nativeBuildInputs = [
    asciidoctor
    installShellFiles
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/rgr \
      --prefix PATH : ${lib.makeBinPath [ ripgrep ]}

    pushd "$(dirname "$(find -path '**/repgrep-stamp' | head -n 1)")"
    installManPage rgr.1
    popd
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # rgr reuses ripgrep's completions; see
    # https://github.com/acheronfail/repgrep/blob/${finalAttrs.version}/.github/workflows/release.yml
    installShellCompletion --cmd rgr \
      --bash <(${lib.getExe ripgrep} --generate complete-bash | sed 's/-c rg/-c rgr/') \
      --zsh <(${lib.getExe ripgrep} --generate complete-zsh | sed 's/-c rg/-c rgr/') \
      --fish <(${lib.getExe ripgrep} --generate complete-fish | sed 's/-c rg/-c rgr/')
  '';

  meta = {
    description = "Interactive replacer for ripgrep that makes it easy to find and replace across files on the command line";
    homepage = "https://github.com/acheronfail/repgrep";
    changelog = "https://github.com/acheronfail/repgrep/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
      unlicense
    ];
    maintainers = with lib.maintainers; [ iamanaws ];
    mainProgram = "rgr";
  };
})
