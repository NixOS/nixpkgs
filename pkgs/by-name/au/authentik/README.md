# authentik

## Update Procedure

This section describes a rough outline of the steps needed to update the `authentik` packages.

For minor updates, this could be all that is required for an update, but major version updates
usually involve updates to the build process and internal dependencies.

- Run `update.sh`:

  This will update the version and hashes of the build in two stages:

  1) Update the version and fetch the sources

  2) Try to build all FOD dependencies for `aarch64-linux` and `x86_64-linux`

  For the second step to succeed, you must ensure `nix` can build packages for both systems.

  The script will pass everything after the first `--` to `nix build`, so you can add builders for other systems like so:

  ```
  -- --builders 'aarch64-builder aarch64-linux - 2 25'
  ```

  If some of the builds fail, you can restart the script and it will only rebuild the missing ones.

  **Note:**  For the script to function correctly, the FOD's must be independent of another.

  E.g. the `proxy` component depends on `authentik-community` via `postPatch`. This has to be
  avoided with `overrideModAttrs.postPatch = ""` for the `goModules` FOD build.

- Ensure the `project.dependencies` from `${src}/pyproject.toml` match the `authentik-django` dependencies.

- Ensure other packages from the `authentik-community` are up-to-date. At the time of writing, this includes:

  - `python-kadmin-rs`
