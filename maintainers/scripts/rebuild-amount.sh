#!/bin/sh

usage () {
  echo 1>&2 "
usage:
  $0
    [--git commit..commit | --git commit]
    [--svn rev:rev | --svn rev]
    [--path path[:path]*]
    [--help]

This program is used to investigate how any changes inside your nixpkgs
repository may hurt.  With these kind of information you may choose wisely
where you should commit your changes.

This program adapts it-self to your versionning system to avoid too much
effort on your Internet bandwidth.  If you need to check more than one
commits / revisions, you may use the following commands:

  --git remotes/trunk..master
  --svn 17670:17677

    Check the differences between each commit separating the first and the
    last commit.

  --path /etc/nixos/nixpkgs:/tmp/nixpkgs_1:/tmp/nixpkgs_2

    Check the differences between multiple directories containing different
    versions of nixpkgs.

All these options exist with one commit / revision argument.  Such options
are used to compare your \$NIXPKGS path with the specified version.

If you omit to mention any other commit / revision, then your \$NIXPKGS path
is compared with its last update.  This command is useful to test code from
a dirty repository.

"

  exit 1;
}

#####################
# Process Arguments #
#####################

: ${NIXPKGS=/etc/nixos/nixpkgs/}

vcs=""
gitCommits=""
svnRevisions=""
pathLocations=""
verbose=false

argfun=""
for arg; do
  if test -z "$argfun"; then
    case $arg in
      --git) vcs="git"; argfun="set_gitCommits";;
      --svn) vcs="svn"; argfun="set_svnRevisions";;
      --path) vcs="path"; argfun="set_pathLocations";;
      --verbose) verbose=true;;
      --help) usage;;
      *) usage;;
    esac
  else
    case $argfun in
      set_*)
        var=$(echo $argfun | sed 's,^set_,,')
        eval $var=$arg
        ;;
    esac
    argfun=""
  fi
done

if $verbose; then
  set -x
else
  set +x
fi

############################
# Find the repository type #
############################

if test -z "$vcs"; then
  if test -x "$NIXPKGS/.git"; then
    if git --git-dir="$NIXPKGS/.git" branch > /dev/null 2>&1; then
      vcs="git"
      gitCommits=$(git --git-dir="$NIXPKGS/.git" log -n 1 --pretty=format:%H 2> /dev/null)
    fi
  elif test -x "$NIXPKGS/.svn"; then
    cd "$NIXPKGS"
    if svn info > /dev/null 2>&1; then
      vcs="svn";
      svnRevisions=$(svn info | sed -n 's,Revision: ,,p')
    fi
    cd -
  else
    usage
  fi
fi

###############################
# Define a storage directory. #
###############################

pkgListDir=""
exitCode=1
cleanup(){
  test -e "$pkgListDir" && rm -rf "$pkgListDir"
  exit $exitCode;
}

trap cleanup EXIT SIGINT SIGQUIT ERR

pkgListDir=$(mktemp --tmpdir -d rebuild-amount-XXXXXXXX)
vcsDir="$pkgListDir/.vcs"

###########################
# Versionning for Dummies #
###########################

path_init() {
  if test "${pathLocations#*:}" = "$pathLocations"; then
    pathLocations="$NIXPKGS:$pathLocations"
  fi
  pathLocations="${pathLocations}:"
}

path_getNext() {
  pathLoc="${pathLocations%%:*}"
  pathLocations="${pathLocations#*:}"
}

path_setPath() {
  path="$pathLoc"
}

path_setName() {
  name=$(echo "$pathLoc" | tr '/' '_')
}

################
# Git Commands #
################

git_init() {
  git clone "$NIXPKGS/.git" "$vcsDir" > /dev/null 2>&1
  if echo "gitCommits" | grep -c "\.\." > /dev/null 2>&1; then
    gitCommits=$(git --git-dir="$vcsDir/.git" log --reverse --pretty=format:%H $gitCommits 2> /dev/null)
  else
    pathLocations="$vcsDir:$NIXPKGS"
    vcs="path"
    path_init
  fi
}

git_getNext() {
  git --git-dir="$vcsDir/.git" checkout $(echo "$gitCommits" | head -n 1) > /dev/null 2>&1
  gitCommits=$(echo "$gitCommits" | sed '1 d')
}

git_setPath() {
  path="$vcsDir"
}

git_setName() {
  name=$(git --git-dir="$vcsDir/.git" log -n 1 --pretty=format:%H  2> /dev/null)
}

#######################
# Subversion Commands #
#######################

svn_init() {
  cp -r "$NIXPKGS" "$vcsDir" > /dev/null 2>&1
  if echo "svnRevisions" | grep -c ":" > /dev/null 2>&1; then
    svnRevisions=$(seq ${svnRevisions%:*} ${svnRevisions#*:})
  else
    pathLocations="$vcsDir:$NIXPKGS"
    vcs="path"
    path_init
  fi
}

svn_getNext() {
  cd "$vcsDir"
  svn checkout $(echo "$svnRevisions" | head -n 1) > /dev/null 2>&1
  cd -
  svnRevisions=$(echo "$svnRevisions" | sed '1 d')
}

svn_setPath() {
  path="$vcsDir"
}

svn_setName() {
  name=$(svn info  2> /dev/null | sed -n 's,Revision: ,,p')
}

####################
# Logical Commands #
####################

init    () { ${vcs}_init; }
getNext () { ${vcs}_getNext; }
setPath () { ${vcs}_setPath; }
setName () { ${vcs}_setName; }


#####################
# Check for Rebuild #
#####################

# Generate the list of all derivations that could be build from a nixpkgs
# respository.  This list of derivation hashes is compared with previous
# lists and a brief summary is produced on the output.

compareNames () {
    nb=$(diff -y --suppress-common-lines --speed-large-files "$pkgListDir/$1.drvs" "$pkgListDir/$2.drvs" 2> /dev/null | wc -l)
    echo "$1 -> $2: $nb"
}

echo "Please wait, this may take some minutes ..."

init
first=""
oldPrev=""

prev=""
curr=""

while true; do
  getNext
  setPath # set path=...
  setName # set name=...
  curr="$name"

  test -z "$curr" && break || true

  nix-instantiate "$path" > "$pkgListDir/$curr.drvs" > /dev/null 2>&1 || true

  if test -n "$prev"; then
    compareNames "$prev" "$curr"
  else
    echo "Number of package to rebuild:"
    first="$curr"
  fi
  oldPrev="$prev"
  prev="$curr"
done

if test "$first" != "$oldPrev"; then
  echo "Number of package to rebuild (first -> last):"
  compareNames "$first" "$curr"
fi

exitCode=0
