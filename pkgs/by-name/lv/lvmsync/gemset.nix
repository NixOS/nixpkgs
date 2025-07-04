{
  git-version-bump = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WlCe2VMVfGXFKYFamW4Ur7ka7e2XtHjZExbfVR8QknU=";
      type = "gem";
    };
    version = "0.15.1";
  };
  lvmsync = {
    dependencies = [
      "git-version-bump"
      "treetop"
    ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-u6Kp42F+3cfZ8j+emIfWuSEPm939t+zJJUvtFd3OrQo=";
      type = "gem";
    };
    version = "3.3.2";
  };
  polyglot = {
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-WdZu9ePBZkMcOcuLfB0Cr0GQUTUvJ5EvakOYGz3vFq8=";
      type = "gem";
    };
    version = "0.3.5";
  };
  treetop = {
    dependencies = [ "polyglot" ];
    source = {
      remotes = [ "https://rubygems.org" ];
      hash = "sha256-baGP0WYqZt5p91wW5jVvNfCzceX+Ws1skrAhKHZos2k=";
      type = "gem";
    };
    version = "1.6.9";
  };
}
