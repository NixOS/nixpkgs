#!/usr/bin/env bash
CMDS=();DESC=();NARGS=$#;ARG1=$1;make_command(){ CMDS+=($1);DESC+=("$2");};usage(){ printf "\nUsage: %s [command]\n\nCommands:\n" $0;line="              ";for((i=0;i<=$(( ${#CMDS[*]} -1));i++));do printf "  %s %s ${DESC[$i]}\n" ${CMDS[$i]} "${line:${#CMDS[$i]}}";done;echo;};runme(){ if test $NARGS -eq 1;then eval "$ARG1"||usage;else usage;fi;}

version="1.12.6";

make_command "about" "About this update script."
about(){
  echo "Documenso upstream needs some fixing before it can be build in a pure sandbox"
  echo "environment. This script does the following:"
  echo "  - download documenso version ${version} from github in a temp dir"
  echo "  - uninstall inngest-cli which runs a binary download script at build time."
  echo "  - upgrade turborepo as the older upstream version 'phones home' at build time."
  echo "  - update the turbo.json to make it work with preset environment vars"
  echo "  - fix the lockfile by generating missing hash signatures"
  echo "  - create patches from changed json files"
}

make_command "update" "Get upstream and prepatch."
update(){

  echo "updating documenso for nixpkgs packaging"
  current_nixpkgs_dir=${PWD}
  temptarfile=/tmp/documenso-v${version}.tar.gz
  tempdir=/tmp/documenso-v${version}

  if [ ! -f "$temptarfile" ]; then
    echo "Tarball does not exist; downloading from github.";
    wget https://github.com/documenso/documenso/archive/refs/tags/v${version}.tar.gz -O $temptarfile
  fi

  rm -Rf $tempdir
  mkdir $tempdir
  tar -xzvf /tmp/documenso-v${version}.tar.gz -C $tempdir --strip-components=1
  cd $tempdir
  git init
  git add package-lock.json package.json turbo.json
  git commit -m "commit4diff" package-lock.json package.json turbo.json

  echo "rm inngest-cli from root"
  npm uninstall inngest-cli

  npx @turbo/codemod migrate . --force

  jq '.envMode="loose"' turbo.json > turbo-patched.json
  cp turbo-patched.json turbo.json

  echo "fix package-lock.json hashes"
  nix run nixpkgs#npm-lockfile-fix -- package-lock.json

  git diff package-lock.json > $current_nixpkgs_dir/package-lock.json.patch
  git diff package.json > $current_nixpkgs_dir/package.json.patch
  git diff turbo.json > $current_nixpkgs_dir/turbo.json.patch
}

runme
