{
  lib,
  libgit2,
}:
{
  libgit2-sys = {
    rustc-link-lib = [ "git2" ];
    rustc-link-search = [ "${libgit2.lib}/lib" ];
  };
}
