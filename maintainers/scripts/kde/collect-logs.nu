#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell
cd $"($env.FILE_PWD)/../../.."

mkdir logs
nix-env -qaP -f . -A kdePackages --json --out-path | from json | values | par-each { |it|
    echo $"Processing ($it.pname)..."
    if "outputs" in $it {
        nix-store --read-log $it.outputs.out | save -f $"logs/($it.pname).log"
    }
}
