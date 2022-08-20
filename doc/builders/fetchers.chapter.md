# Fetchers {#chap-pkgs-fetchers}

Building software with Nix often requires downloading source code and other files from the internet.
`nixpkgs` provides *fetchers* for different protocols and services. Fetchers are functions that simplify downloading files.

## Caveats

Fetchers create [fixed output derivations](https://nixos.org/manual/nix/stable/#fixed-output-drvs) from downloaded files.
Nix can reuse the downloaded files via the hash of the resulting derivation.

The fact that the hash belongs to the Nix derivation output and not the file itself can lead to confusion.
For example, consider the following fetcher:

```nix
fetchurl {
  url = "http://www.example.org/hello-1.0.tar.gz";
  sha256 = "0v6r3wwnsk5pdjr188nip3pjgn1jrn5pc5ajpcfy6had6b3v4dwm";
};
```

A common mistake is to update a fetcher’s URL, or a version parameter, without updating the hash.

```nix
fetchurl {
  url = "http://www.example.org/hello-1.1.tar.gz";
  sha256 = "0v6r3wwnsk5pdjr188nip3pjgn1jrn5pc5ajpcfy6had6b3v4dwm";
};
```

**This will reuse the old contents**.
Remember to invalidate the hash argument, in this case by setting the `sha256` attribute to an empty string.

```nix
fetchurl {
  url = "http://www.example.org/hello-1.1.tar.gz";
  sha256 = "";
};
```

Use the resulting error message to determine the correct hash.

```
error: hash mismatch in fixed-output derivation '/path/to/my.drv':
         specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
            got:    sha256-RApQUm78dswhBLC/rfU9y0u6pSAzHceIJqgmetRD24E=
```

A similar problem arises while testing changes to a fetcher's implementation. If the output of the derivation already exists in the Nix store, test failures can go undetected. The [`invalidateFetcherByDrvHash`](#tester-invalidateFetcherByDrvHash) function helps prevent reusing cached derivations.

## `fetchurl` and `fetchzip` {#fetchurl}

Two basic fetchers are `fetchurl` and `fetchzip`. Both of these have two required arguments, a URL and a hash. The hash is typically `sha256`, although many more hash algorithms are supported. Nixpkgs contributors are currently recommended to use `sha256`. This hash will be used by Nix to identify your source. A typical usage of `fetchurl` is provided below.

```nix
{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "hello";
  src = fetchurl {
    url = "http://www.example.org/hello.tar.gz";
    sha256 = "1111111111111111111111111111111111111111111111111111";
  };
}
```

The main difference between `fetchurl` and `fetchzip` is in how they store the contents. `fetchurl` will store the unaltered contents of the URL within the Nix store. `fetchzip` on the other hand, will decompress the archive for you, making files and directories directly accessible in the future. `fetchzip` can only be used with archives. Despite the name, `fetchzip` is not limited to .zip files and can also be used with any tarball.

## `fetchpatch` {#fetchpatch}

`fetchpatch` works very similarly to `fetchurl` with the same arguments expected. It expects patch files as a source and performs normalization on them before computing the checksum. For example, it will remove comments or other unstable parts that are sometimes added by version control systems and can change over time.

- `relative`: Similar to using `git-diff`'s `--relative` flag, only keep changes inside the specified directory, making paths relative to it.
- `stripLen`: Remove the first `stripLen` components of pathnames in the patch.
- `extraPrefix`: Prefix pathnames by this string.
- `excludes`: Exclude files matching these patterns (applies after the above arguments).
- `includes`: Include only files matching these patterns (applies after the above arguments).
- `revert`: Revert the patch.

Note that because the checksum is computed after applying these effects, using or modifying these arguments will have no effect unless the `sha256` argument is changed as well.


Most other fetchers return a directory rather than a single file.

## `fetchsvn` {#fetchsvn}

Used with Subversion. Expects `url` to a Subversion directory, `rev`, and `sha256`.

## `fetchgit` {#fetchgit}

Used with Git. Expects `url` to a Git repo, `rev`, and `sha256`. `rev` in this case can be full the git commit id (SHA1 hash) or a tag name like `refs/tags/v1.0`.

Additionally, the following optional arguments can be given: `fetchSubmodules = true` makes `fetchgit` also fetch the submodules of a repository. If `deepClone` is set to true, the entire repository is cloned as opposing to just creating a shallow clone. `deepClone = true` also implies `leaveDotGit = true` which means that the `.git` directory of the clone won't be removed after checkout.

If only parts of the repository are needed, `sparseCheckout` can be used. This will prevent git from fetching unnecessary blobs from server, see [git sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) for more information:

```nix
{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "hello";
  src = fetchgit {
    url = "https://...";
    sparseCheckout = ''
      directory/to/be/included
      another/directory
    '';
    sha256 = "0000000000000000000000000000000000000000000000000000";
  };
}
```

## `fetchfossil` {#fetchfossil}

Used with Fossil. Expects `url` to a Fossil archive, `rev`, and `sha256`.

## `fetchcvs` {#fetchcvs}

Used with CVS. Expects `cvsRoot`, `tag`, and `sha256`.

## `fetchhg` {#fetchhg}

Used with Mercurial. Expects `url`, `rev`, and `sha256`.

A number of fetcher functions wrap part of `fetchurl` and `fetchzip`. They are mainly convenience functions intended for commonly used destinations of source code in Nixpkgs. These wrapper fetchers are listed below.

## `fetchFromGitea` {#fetchfromgitea}

`fetchFromGitea` expects five arguments. `domain` is the gitea server name. `owner` is a string corresponding to the Gitea user or organization that controls this repository. `repo` corresponds to the name of the software repository. These are located at the top of every Gitea HTML page as `owner`/`repo`. `rev` corresponds to the Git commit hash or tag (e.g `v1.0`) that will be downloaded from Git. Finally, `sha256` corresponds to the hash of the extracted directory. Again, other hash algorithms are also available but `sha256` is currently preferred.

## `fetchFromGitHub` {#fetchfromgithub}

`fetchFromGitHub` expects four arguments. `owner` is a string corresponding to the GitHub user or organization that controls this repository. `repo` corresponds to the name of the software repository. These are located at the top of every GitHub HTML page as `owner`/`repo`. `rev` corresponds to the Git commit hash or tag (e.g `v1.0`) that will be downloaded from Git. Finally, `sha256` corresponds to the hash of the extracted directory. Again, other hash algorithms are also available, but `sha256` is currently preferred.

`fetchFromGitHub` uses `fetchzip` to download the source archive generated by GitHub for the specified revision. If `leaveDotGit`, `deepClone` or `fetchSubmodules` are set to `true`, `fetchFromGitHub` will use `fetchgit` instead. Refer to its section for documentation of these options.

## `fetchFromGitLab` {#fetchfromgitlab}

This is used with GitLab repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromGitiles` {#fetchfromgitiles}

This is used with Gitiles repositories. The arguments expected are similar to `fetchgit`.

## `fetchFromBitbucket` {#fetchfrombitbucket}

This is used with BitBucket repositories. The arguments expected are very similar to fetchFromGitHub above.

## `fetchFromSavannah` {#fetchfromsavannah}

This is used with Savannah repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromRepoOrCz` {#fetchfromrepoorcz}

This is used with repo.or.cz repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromSourcehut` {#fetchfromsourcehut}

This is used with sourcehut repositories. Similar to `fetchFromGitHub` above,
it expects `owner`, `repo`, `rev` and `sha256`, but don't forget the tilde (~)
in front of the username! Expected arguments also include `vc` ("git" (default)
or "hg"), `domain` and `fetchSubmodules`.

If `fetchSubmodules` is `true`, `fetchFromSourcehut` uses `fetchgit`
or `fetchhg` with `fetchSubmodules` or `fetchSubrepos` set to `true`,
respectively. Otherwise, the fetcher uses `fetchzip`.
