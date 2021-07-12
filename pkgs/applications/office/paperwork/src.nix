{fetchFromGitLab}:
rec {
  version = "2.0.3";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "02c2ysca75j59v87n1axqfncvs167kmdr40m0f05asdh2akwrbi9";
  };
  sample_documents = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork-test-documents";
    group = "World";
    owner = "OpenPaperwork";
    # https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/blob/master/paperwork-gtk/src/paperwork_gtk/model/help/screenshot.sh see TEST_DOCS_TAG
    rev = "1.0";
    sha256 = "155nhw2jmlgfi6c3wm241vrr3yma6lw85k9lxn844z96kyi7wbpr";
  };

}
