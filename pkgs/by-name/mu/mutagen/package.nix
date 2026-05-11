{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchzip,
  installShellFiles,
}:

buildGoModule rec {
  pname = "mutagen";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "mutagen-io";
    repo = "mutagen";
    rev = "v${version}";
    hash = "sha256-eT1B2ifs1BA2wcVyz9C9F8YoSbGcpGghu5Z3UrjfBOc=";
  };

  vendorHash = "sha256-RVVUeNfp/HWd3/5uCyaDGw6bXFJvfomhu//829jO+qE=";

  agents = fetchzip {
    name = "mutagen-agents-${version}";
    # The package architecture does not matter since all packages contain identical mutagen-agents.tar.gz.
    url = "https://github.com/mutagen-io/mutagen/releases/download/v${version}/mutagen_linux_amd64_v${version}.tar.gz";
    stripRoot = false;
    postFetch = ''
      rm $out/mutagen # Keep only mutagen-agents.tar.gz.
    '';
    hash = "sha256-ltObD3MCSYE7IJaEDyB35CqmtUKintsaD0sMQdFAfYY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  subPackages = [
    "cmd/mutagen"
    "cmd/mutagen-agent"
  ];

  tags = [
    "mutagencli"
    "mutagenagent"
  ];

  postInstall = ''
    install -d $out/libexec
    ln -s ${agents}/mutagen-agents.tar.gz $out/libexec/

    $out/bin/mutagen generate \
      --bash-completion-script mutagen.bash \
      --fish-completion-script mutagen.fish \
      --zsh-completion-script mutagen.zsh

    installShellCompletion \
      --cmd mutagen \
      --bash mutagen.bash \
      --fish mutagen.fish \
      --zsh mutagen.zsh
  '';

  meta = {
    description = "Make remote development work with your local tools";
    homepage = "https://mutagen.io/";
    changelog = "https://github.com/mutagen-io/mutagen/releases/tag/v${version}";
    maintainers = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mit;
  };
}
