{
  fetchFromGitLab,
  srcOnly,
  fetchpatch,
  stdenv,
}:
rec {
  version = "2.2.5";
  src = srcOnly {
    pname = "paperwork-patched-src";
    inherit version stdenv;
    src = fetchFromGitLab {
      domain = "gitlab.gnome.org";
      repo = "paperwork";
      group = "World";
      owner = "OpenPaperwork";
      rev = version;
      sha256 = "sha256-PRh0ohmPLwpM76qYfbExFqq4OK6Hm0fbdzrjXungSoY=";
    };
    patches = [
      # fix installing translations
      # remove on next release
      (
        assert version == "2.2.5";
        fetchpatch {
          url = "https://gitlab.gnome.org/World/OpenPaperwork/paperwork/-/commit/b8e2633ace0f3d9d57e68c27db8f594b8a5ddd7e.patch";
          hash = "sha256-VUT86kF0ZHLGK457ZrrIBMeiZqg/rPRpbkBA/ua9rU8=";
        }
      )
    ];
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
