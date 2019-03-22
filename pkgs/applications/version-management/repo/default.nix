{ stdenv, coreutils, python }:

stdenv.mkDerivation rec {
  version = "1.25";
  name = "repo-${version}";
  buildCommand = ''
    mkdir -p $out/bin
    echo "#!${python}/bin/python" | cat - $repo_script > $out/bin/repo
    chmod a+x $out/bin/repo
  '';
  # The repo script was downloaded with:
  #
  #    curl https://storage.googleapis.com/git-repo-downloads/repo > repo-1.25
  #
  # The reason a copy is cached instead of dynamically downloaded is because the
  # URL is not versioned meaning the contents can change which would break this derivation.
  # This could be fixed if this tool is uploaded to some server where it is versioned and
  # guaranteed not to change.  Until then, a copy is just inclueded here.
  repo_script = ./repo- + version;

  meta = {
    homepage = https://gerrit.googlesource.com/git-repo/;
    description = "A git wrapper to manage multiple repositories";
    license = stdenv.lib.licenses.asl20;
    platformer = stdenv.lib.platforms.all;
  };
}
