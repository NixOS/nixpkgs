{fetchFromGitLab}:
rec {
  version = "2.0.1";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "16pc4drwpjl4937wdavs6wk0j1qs474b072wplhs8ywxfgqip1h4";
  };
}
