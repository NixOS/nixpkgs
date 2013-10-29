SF_redirect () {
  redirect
  process 'http://[a-z]+[.]dl[.]sourceforge[.]net/' 'mirror://sourceforge/'
  process '[?].*' ''
}

SF_version_dir () {
  version_link 'http://sourceforge.net/.+/[0-9.]+/$'
}

GH_latest () {
  prefetch_command_rel ../fetchgit/nix-prefetch-git
  rev "$(curl "$CURRENT_URL/commits" | grep /commit/ | head -n 1 | xargs basename )"
}
