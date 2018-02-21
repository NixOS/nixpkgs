{ stdenv, fetchurl, python }:

with python.pkgs;

buildPythonApplication rec {
  pname = "haxor-news";
  version = "0.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5b9af8338a0f8b95a8133b66ef106553823813ac171c0aefa3f3f2dbeb4d7f88";
  };

  propagatedBuildInputs = [
    click
    colorama
    requests
    pygments
    prompt_toolkit
    six
  ];

  disabledTests = stdenv.lib.concatMapStringsSep " and " (s: "not " + s) [
    "test_ask"
    "test_best"
    "test_hiring"
    "test_freelance"
    "test_jobs"
    "test_new"
    "test_onion"
    "test_show"
    "test_top"
    "test_user"
    "test_view"
    "test_ask"
    "test_best"
    "test_format_markdown"
    "test_headlines_message"
    "test_hiring_and_freelance"
    "test_jobs"
    "test_new"
    "test_onion"
    "test_show"
    "test_top"
    "test_user"
    "test_view_setup_query_recent"
    "test_view_setup_query_unseen"
    "test_format_comment"
    "test_format_index_title"
    "test_format_item"
    "test_print_comments_unseen"
    "test_print_comments_unseen_hide_non_matching"
    "test_print_comments_regex"
    "test_print_comments_regex_hide_non_matching"
    "test_print_comments_regex_seen"
    "test_print_item_not_found"
    "test_print_items"
    "test_print_tip_view"
    "test_match_comment_unseen"
    "test_match_regex"
    "test_match_regex_user"
    "test_match_regex_item"
    "test_view"
    "test_view_comments"
    "test_view_no_url"
    "test_view_browser_url"
    "test_view_browser_comments"
  ];

  checkInputs = [ mock pexpect python.pkgs.pytest ];

  checkPhase = ''
    py.test -k "${disabledTests}"
    #PATH=$out/bin:$PATH ${python.interpreter} -m unittest discover -s tests -v
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/donnemartin/haxor-news;
    description = "Browse Hacker News like a haxor";
    license = licenses.asl20;
    maintainers = with maintainers; [ matthiasbeyer ];
  };

}
