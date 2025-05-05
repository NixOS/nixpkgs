import ./generic.nix {
  version = "11.0.1";
  hash = "sha256-hsJfJOJ6mTIGGV+0YwSA9SYsLXxI1VTXzc+SyXJJ69Q=";
  npmDepsHash = "sha256-laHHXq59/7+rJSYTD1Aq/AvFcio6vsnWkeV8enq3yTg=";
  vendorHash = "sha256-8fa6l89+6NhVsi6VuTvQs35E3HuiBFxM8NUQ/jzlzV0=";
  lts = true;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/lts.nix"
  ];
}
