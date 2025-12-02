{
  lib,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
}:

buildGoModule (finalAttrs: {
  # "chatgpt-cli" is taken by another package with the same upsteam name.
  # To keep "pname" and "package attribute name" identical, the owners name (kardolus) gets prefixed as identifier.
  pname = "kardolus-chatgpt-cli";
  version = "1.8.11";

  src = fetchFromGitHub {
    owner = "kardolus";
    repo = "chatgpt-cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-PcZB/XDvCPkbfJmp0c43QCCv0Z5Ih6ZyHYrCdMciDTU=";
  };

  vendorHash = null;
  # The tests of kardolus/chatgpt-cli require an OpenAI API Key to be present in the environment,
  # (e.g. https://github.com/kardolus/chatgpt-cli/blob/v1.8.11/test/contract/contract_test.go#L35)
  # which will not be the case in the pipeline.
  # Therefore, tests must be skipped.
  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  postFixup = ''
    wrapProgram $out/bin/chatgpt \
      --run "mkdir -p ~/.chatgpt-cli" \
      --set-default CHATGPT_CLI_HISTORY_DIR ~/.chatgpt-cli
  '';

  meta = {
    description = "Command-line interface for ChatGPT";
    longDescription = ''
      ChatGPT CLI is a versatile tool for interacting with LLMs through OpenAI, Azure, and other popular providers like Perplexity AI and Llama.
      It supports prompt files, history tracking, and live data injection via MCP (Model Context Protocol),
      making it ideal for both casual users and developers seeking a powerful, customizable GPT experience.
    '';
    homepage = "https://github.com/kardolus/chatgpt-cli";
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ralleka ];
    mainProgram = "chatgpt";
  };
})
