{
  beta = import ./browser.nix {
    channel = "beta";
    version = "129.0.2792.12";
    revision = "1";
    hash = "sha256-LWu5DKCoGSFqUZqgvKx3aoZRzAf6FR3hJnk/agAV9sI=";
  };
  dev = import ./browser.nix {
    channel = "dev";
    version = "129.0.2792.10";
    revision = "1";
    hash = "sha256-jw/muaunLlrtZADrD7asVH+o/u3cp3NyvjRXqPWyHJI=";
  };
  stable = import ./browser.nix {
    channel = "stable";
    version = "128.0.2739.54";
    revision = "1";
    hash = "sha256-qiLZExLU3f6l+qPEGiqOuDgjqOtSyhPwSt7kQfBBSyg=";
  };
}
