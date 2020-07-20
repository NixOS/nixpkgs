#!/bin/sh


sendto="git@github.com:nixos/nixpkgs.git"

IFS=$'\n'
for branch in $(git branch -r | grep origin | grep -v master | grep -v HEAD); do
    origin=$(echo "$branch" | xargs echo)
    branch=$(echo "$branch" | xargs echo | sed -e 's#^origin/##')

    echo "Starting $origin -> $branch"
    git checkout "$origin"
    git checkout -b "$branch"
    git push "$sendto" "$branch"


    printf "\n\n\n\n"
done
