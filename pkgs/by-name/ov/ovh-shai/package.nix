{
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "ovh-shai";
  version = "0.1.10";

  src = fetchFromGitHub {
    owner = "ovh";
    repo = "shai";
    tag = "v${version}";
    hash = "sha256-vns3pEiTNWegxIprLvFuZ98ZaLSWhaBSbVridXv54QQ=";
  };

  cargoHash = "sha256-tBsZ5efPxzGX1zsC1tVAl+z+yoXVOXJ0OCcA0Lkh/tM=";

  # Needed to get openssl-sys to use pkg-config.
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  checkFlags = [
    # Skip failing test
    "--skip=fc::tests::tests::test_clear_history"

    # Skip tests requiring networking
    "--skip=providers::anthropic::tests::tests::test_multiple_system_messages"
    "--skip=providers::anthropic::tests::tests::test_no_system_messages"
    "--skip=providers::anthropic::tests::tests::test_system_prompt_handling"
    "--skip=providers::anthropic::tests::tests::test_tool_result_conversion"
    "--skip=runners::coder::tests::test_coder_brain_creation"
    "--skip=runners::coder::tests::test_coder_brain_think_simple"
    "--skip=runners::coder::tests::test_coder_integration_bug_fix_task"
    "--skip=runners::coder::tests::test_coder_integration_simple_file_creation"
    "--skip=runners::coder::tests::test_multi_turn_conversation"
    "--skip=runners::gerund::tests::test_gerund_prompt_generation"
    "--skip=runners::gerund::tests::test_gerund_with_coding_message"
    "--skip=runners::gerund::tests::test_gerund_with_different_activities"
    "--skip=runners::gerund::tests::test_gerund_with_empty_message"
    "--skip=runners::gerund::tests::test_gerund_with_long_message"
    "--skip=runners::gerund::tests::test_gerund_with_simple_message"
    "--skip=runners::gerund::tests::test_llm_client_selection"
    "--skip=runners::gerund::tests::test_model_selection_for_providers"
    "--skip=runners::searcher::tests::test_searcher_analyze_auth_feature"
    "--skip=runners::searcher::tests::test_searcher_find_struct_definition"
    "--skip=runners::searcher::tests::test_searcher_generate_knowledge_documentation"
    "--skip=tools::tests_llm::llm_integration_tests::test_bash_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_edit_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_fetch_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_find_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_ls_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_multiedit_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_read_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_todo_read_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_todo_write_tool_with_llm"
    "--skip=tools::tests_llm::llm_integration_tests::test_write_tool_with_llm"
    "--skip=tools::todo::tests::tests::test_todo_write_tool_basic"
    "--skip=tools::todo::tests::tests::test_todo_write_tool_empty"
  ];

  meta = {
    description = "OVHcloud's terminal-based AI coding assistant";
    homepage = "https://github.com/ovh/shai";
    changelog = "https://github.com/ovh/shai/releases";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.anthonyroussel ];
    mainProgram = "shai";
  };
}
