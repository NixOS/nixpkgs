{fetchFromGitLab}:
rec {
  version = "2.0.2";
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    repo = "paperwork";
    group = "World";
    owner = "OpenPaperwork";
    rev = version;
    sha256 = "1di7nnl8ywyiwfpl5m1kvip1m0hvijbmqmkdpviwqw7ajizrr1ly";
  };
}
