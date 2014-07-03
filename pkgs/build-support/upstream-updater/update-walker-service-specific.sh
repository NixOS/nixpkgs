SF_redirect () {
  redirect
  process 'http://[a-z]+[.]dl[.]sourceforge[.]net/' 'mirror://sourceforge/'
  process '[?].*' ''
}

SF_version_dir () {
  version_link 'http://sourceforge.net/.+/'"$1"'[0-9.]+/$'
}

GH_latest () {
  prefetch_command_rel ../fetchgit/nix-prefetch-git
  revision "$("$(dirname "$0")/urls-from-page.sh" "$CURRENT_URL/commits" | grep /commit/ | head -n 1 | xargs basename )"
  version '.*' "git-$(date +%Y-%m-%d)"
  NEED_TO_CHOOSE_URL=
}
