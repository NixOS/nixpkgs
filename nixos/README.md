# NixOS

NixOS is a Linux distribution based on the purely functional package
management system Nix.  More information can be found at
https://nixos.org/nixos and in the manual in doc/manual.

## Testing changes

You can add new module to your NixOS configuration file (usually it’s `/etc/nixos/configuration.nix`). And do `sudo nixos-rebuild test -I nixpkgs=<path to your local nixpkgs folder> --fast`.

## Commit conventions

- Make sure you read about the [commit conventions](../CONTRIBUTING.md#commit-conventions) common to Nixpkgs as a whole.

- Format the commit messages in the following way:

  ```
  nixos/(module): (init module | add setting | refactor | etc)

  (Motivation for change. Link to release notes. Additional information.)
  ```

  Examples:

  * nixos/hydra: add bazBaz option

    Dual baz behavior is needed to do foo.
  * nixos/nginx: refactor config generation

    The old config generation system used impure shell scripts and could break in specific circumstances (see #1234).

## Reviewing contributions

When changing the bootloader installation process, extra care must be taken. Grub installations cannot be rolled back, hence changes may break people’s installations forever. For any non-trivial change to the bootloader please file a PR asking for review, especially from \@edolstra.

### Module updates

Module updates are submissions changing modules in some ways. These often contains changes to the options or introduce new options.

Reviewing process:

- Ensure that the module maintainers are notified.
  - [CODEOWNERS](https://help.github.com/articles/about-codeowners/) will make GitHub notify users based on the submitted changes, but it can happen that it misses some of the package maintainers.
- Ensure that the module tests, if any, are succeeding.
  - You may invoke OfBorg with `@ofborg test <module>` to build `nixosTests.<module>`
- Ensure that the introduced options are correct.
  - Type should be appropriate (string related types differs in their merging capabilities, `loaOf` and `string` types are deprecated).
  - Description, default and example should be provided.
- Ensure that option changes are backward compatible.
  - `mkRenamedOptionModuleWith` provides a way to make renamed option backward compatible.
  - Use `lib.versionAtLeast config.system.stateVersion "24.05"` on backward incompatible changes which may corrupt, change or update the state stored on existing setups.
- Ensure that removed options are declared with `mkRemovedOptionModule`.
- Ensure that changes that are not backward compatible are mentioned in release notes.
- Ensure that documentations affected by the change is updated.

Sample template for a module update review is provided below.

```markdown
##### Reviewed points

- [ ] changes are backward compatible
- [ ] removed options are declared with `mkRemovedOptionModule`
- [ ] changes that are not backward compatible are documented in release notes
- [ ] module tests succeed on ARCHITECTURE
- [ ] options types are appropriate
- [ ] options description is set
- [ ] options example is provided
- [ ] documentation affected by the changes is updated

##### Possible improvements

##### Comments
```

### New modules

New modules submissions introduce a new module to NixOS.

Reviewing process:

- Ensure that all file paths [fit the guidelines](../CONTRIBUTING.md#file-naming-and-organisation).
- Ensure that the module tests, if any, are succeeding.
- Ensure that new module tests are added to the package `passthru.tests`.
- Ensure that the introduced options are correct.
  - Type should be appropriate (string related types differs in their merging capabilities, `loaOf` and `string` types are deprecated).
  - Description, default and example should be provided.
- Ensure that module `meta` field is present
  - Maintainers should be declared in `meta.maintainers`.
  - Module documentation should be declared with `meta.doc`.
- Ensure that the module respect other modules functionality.
  - For example, enabling a module should not open firewall ports by default.

Sample template for a new module review is provided below.

```markdown
##### Reviewed points

- [ ] module path fits the guidelines
- [ ] module tests, if any, succeed on ARCHITECTURE
- [ ] module tests, if any, are added to package `passthru.tests`
- [ ] options have appropriate types
- [ ] options have default
- [ ] options have example
- [ ] options have descriptions
- [ ] No unneeded package is added to `environment.systemPackages`
- [ ] `meta.maintainers` is set
- [ ] module documentation is declared in `meta.doc`

##### Possible improvements

##### Comments
```
