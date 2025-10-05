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

rustPlatform.buildRustPackage rec {
  pname = "repgrep";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "acheronfail";
    repo = "repgrep";
    rev = version;
    hash = "sha256-hLRl8mKRaufneJNBQqPsH+48ZQGxFBNgulXcaK4/6s4=";
  };

  cargoHash = "sha256-ALp6BQNWpylHPBeLs/4hugN1ulCdctOmgu55Lmt8wjI=";

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
    # As it can be seen here: https://github.com/acheronfail/repgrep/blob/0.16.1/.github/workflows/release.yml#L206, the completions are just the same as ripgrep
    installShellCompletion --cmd rgr \
      --bash <(${lib.getExe ripgrep} --generate complete-bash | sed 's/-c rg/-c rgr/') \
      --zsh <(${lib.getExe ripgrep} --generate complete-zsh | sed 's/-c rg/-c rgr/') \
      --fish <(${lib.getExe ripgrep} --generate complete-fish | sed 's/-c rg/-c rgr/')
  '';

  meta = with lib; {
    description = "Interactive replacer for ripgrep that makes it easy to find and replace across files on the command line";
    homepage = "https://github.com/acheronfail/repgrep";
    changelog = "https://github.com/acheronfail/repgrep/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
      unlicense
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "rgr";
  };
}
