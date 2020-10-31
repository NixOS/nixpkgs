{fetchFromGitLab}:
rec {
  version = "2.0";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "0879wvl3hk74kwnaa64q6prfg2kjaa7nrzahaw2zcipdpf5h2mkm";
  };
}
