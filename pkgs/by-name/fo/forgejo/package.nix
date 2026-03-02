import ./generic.nix {
  version = "14.0.2";
  hash = "sha256-jgRyFfbzJ0Camotkn7f/tvSi7jKIhqEpGVZV8xw5uDQ=";
  npmDepsHash = "sha256-gyEr5uNZfBELxbvQeZ48xqtay7ObQL4dQaFO9yPC2Hg=";
  vendorHash = "sha256-RusaQJXToLGL0pdJtCZBQvlTQfDXoaD6dhHNmHQ5Ozk=";
  lts = false;
  nixUpdateExtraArgs = [
    "--override-filename"
    "pkgs/by-name/fo/forgejo/package.nix"
  ];
}
