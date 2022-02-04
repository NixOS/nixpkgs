{fetchFromGitLab}:
rec {
  version = "2.1.0";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "0d1cw6k1giqs8ji8h3h97ckb134s8pszgip0nac5hmw0mvqq84xa";
  };
  sample_documents = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork-test-documents";
    group = "World";
    owner = "OpenPaperwork";
    # https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/blob/master/paperwork-gtk/src/paperwork_gtk/model/help/screenshot.sh see TEST_DOCS_TAG
    rev = "2.1";
    sha256 = "0m79fgc1ycsj0q0alqgr0axn16klz1sfs2km1h83zn3kysqcs6xr";
  };

}
