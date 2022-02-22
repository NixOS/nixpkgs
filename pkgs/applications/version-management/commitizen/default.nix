{ buildPythonApplication
, colorama
, decli
, fetchFromGitHub
, git
, jinja2
, lib
, packaging
, poetry
, pytest-freezegun
, pytest-mock
, pytest-regressions
, pytestCheckHook
, pyyaml
, questionary
, termcolor
, tomlkit
, typing-extensions

, argcomplete, fetchPypi
}:

let
  # NOTE: Upstream requires argcomplete <2, so we make it here.
  argcomplete_1 = argcomplete.overrideAttrs (old: rec {
    version = "1.12.3";
    src = fetchPypi {
      inherit (old) pname;
      inherit version;
      sha256 = "sha256-LH2//YwEXqU0kh5jsL5v5l6IWZmQ2NxAisjFQrcqVEU=";
    };
  });
in

buildPythonApplication rec {
  pname = "commitizen";
  version = "2.21.2";

  src = fetchFromGitHub {
    owner = "commitizen-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ZFKUG8dE1hpWPGitdQlYeBSzWn3LPR7VGWsuq1Le5OQ=";
    deepClone = true;
  };

  format = "pyproject";

  nativeBuildInputs = [ poetry ];

  propagatedBuildInputs = [
    termcolor
    questionary
    colorama
    decli
    tomlkit
    jinja2
    pyyaml
    argcomplete_1
    typing-extensions
    packaging
  ];

  doCheck = true;
  checkInputs = [
    pytestCheckHook
    pytest-freezegun
    pytest-mock
    pytest-regressions
    argcomplete_1
    git
  ];

  # NB: These require full git history
  disabledTests = [
    "test_breaking_change_content_v1"
    "test_breaking_change_content_v1_beta"
    "test_breaking_change_content_v1_multiline"
    "test_bump_command_prelease"
    "test_bump_dry_run"
    "test_bump_files_only"
    "test_bump_local_version"
    "test_bump_major_increment"
    "test_bump_minor_increment"
    "test_bump_on_git_with_hooks_no_verify_disabled"
    "test_bump_on_git_with_hooks_no_verify_enabled"
    "test_bump_patch_increment"
    "test_bump_tag_exists_raises_exception"
    "test_bump_when_bumpping_is_not_support"
    "test_bump_when_version_inconsistent_in_version_files"
    "test_bump_with_changelog_arg"
    "test_bump_with_changelog_config"
    "test_bump_with_changelog_to_stdout_arg"
    "test_changelog_config_flag_increment"
    "test_changelog_config_start_rev_option"
    "test_changelog_from_start"
    "test_changelog_from_version_zero_point_two"
    "test_changelog_hook"
    "test_changelog_incremental_angular_sample"
    "test_changelog_incremental_keep_a_changelog_sample"
    "test_changelog_incremental_keep_a_changelog_sample_with_annotated_tag"
    "test_changelog_incremental_with_release_candidate_version"
    "test_changelog_is_persisted_using_incremental"
    "test_changelog_multiple_incremental_do_not_add_new_lines"
    "test_changelog_replacing_unreleased_using_incremental"
    "test_changelog_with_different_cz"
    "test_get_commits"
    "test_get_commits_author_and_email"
    "test_get_commits_with_signature"
    "test_get_latest_tag_name"
    "test_is_staging_clean_when_updating_file"
    "test_none_increment_should_not_call_git_tag_and_error_code_is_not_zero"
    "test_prevent_prerelease_when_no_increment_detected"
  ];

  meta = with lib; {
    description = "Tool to create committing rules for projects, auto bump versions, and generate changelogs";
    homepage = "https://github.com/commitizen-tools/commitizen";
    license = licenses.mit;
    maintainers = with maintainers; [ lovesegfault ];
  };
}
