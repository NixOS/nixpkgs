{fetchFromGitLab}:
rec {
  version = "2.2.1";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "sha256-OFVj9INDiOpGd5N3ziMBWt3/IdmpInc+jEAxW3GcvOA=";
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
