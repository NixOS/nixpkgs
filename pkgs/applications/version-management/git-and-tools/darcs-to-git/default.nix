{ stdenv, fetchgit, ruby, gnugrep, diffutils, git, darcs }:

stdenv.mkDerivation rec {
  name = "darcs-to-git-${version}";
  version = "2015-06-04";

  src = fetchgit {
    url = "git://github.com/purcell/darcs-to-git.git";
    rev = "e5fee32495908fe0f7d700644c7b37347b7a0a5b";
    sha256 = "0lxcx0x0m1cv2j4x9ykpjf6r2zg6lh5rya016x93vkmlzxm3f0ji";
  };

  patchPhase = let
    matchExecution = ''(\<(output_of|system|run)\([^"%]*("|%w\()|^[^"`]*`)'';
  in ''
    sed -r -i \
      -e '1s|^#!.*|#!${ruby}/bin/ruby|' \
      -e 's!${matchExecution}git\>!\1${git}/bin/git!' \
      -e 's!${matchExecution}darcs\>!\1${darcs}/bin/darcs!' \
      -e 's!${matchExecution}diff\>!\1${diffutils}/bin/diff!' \
      -e 's!\<egrep\>!${gnugrep}/bin/egrep!g' \
      -e 's!%w\(darcs init\)!%w(${darcs}/bin/darcs init)!' \
      darcs-to-git
  '';

  installPhase = ''
    install -vD darcs-to-git "$out/bin/darcs-to-git"
  '';

  doCheck = true;

  checkPhase = ''
    orig_dir="$(pwd)"
    darcs_repos="$(pwd)/darcs_test_repos"
    git_repos="$(pwd)/git_test_repos"
    test_home="$(pwd)/test_home"
    mkdir "$darcs_repos" "$git_repos" "$test_home"
    cd "$darcs_repos"
    ${darcs}/bin/darcs init
    echo "this is a test file" > new_file1
    ${darcs}/bin/darcs add new_file1
    HOME="$test_home" ${darcs}/bin/darcs record -a -m c1 -A none
    echo "testfile1" > new_file1
    echo "testfile2" > new_file2
    ${darcs}/bin/darcs add new_file2
    HOME="$test_home" ${darcs}/bin/darcs record -a -m c2 -A none
    ${darcs}/bin/darcs mv new_file2 only_one_file
    rm -f new_file1
    HOME="$test_home" ${darcs}/bin/darcs record -a -m c3 -A none
    cd "$git_repos"
    HOME="$test_home" PATH= "$orig_dir/darcs-to-git" "$darcs_repos"
    assertFileContents() {
      echo -n "File $1 contains '$2'..." >&2
      if [ "x$(cat "$1")" = "x$2" ]; then
        echo " passed." >&2
        return 0
      else
        echo " failed: '$(cat "$1")' != '$2'" >&2
        return 1
      fi
    }
    echo "Checking if converted repository matches original repository:" >&2
    assertFileContents only_one_file testfile2
    ${git}/bin/git reset --hard HEAD^
    assertFileContents new_file1 testfile1
    assertFileContents new_file2 testfile2
    ${git}/bin/git reset --hard HEAD^
    assertFileContents new_file1 "this is a test file"
    echo "All checks passed." >&2
    cd "$orig_dir"
    rm -rf "$darcs_repos" "$git_repos" "$test_home"
  '';

  meta = {
    description = "Converts a Darcs repository into a Git repository";
    homepage = "http://www.sanityinc.com/articles/converting-darcs-repositories-to-git";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.unix;
  };
}
