# OpenModelica packaging notes

Use the package-local update script to refresh the OpenModelica source and the
release-pinned Modelica Standard Library sources together:

```sh
./pkgs/by-name/op/openmodelica/update.py --version 1.28.0 --in-place
```

For local testing against an unreleased upstream revision, ask it to print an
override instead of editing `package.nix`:

```sh
./pkgs/by-name/op/openmodelica/update.py --rev master --print-override
```

The script updates or prints `srcRev`, `srcHash`, and
`passthru.modelicaStandardLibrarySources`. The library revisions come from the
selected OpenModelica source's `libraries/install-index.json`.
