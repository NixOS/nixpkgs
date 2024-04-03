# Fetchers {#chap-pkgs-fetchers}

Building software with Nix often requires downloading source code and other files from the internet.
To this end, we use functions that we call _fetchers_, which obtain remote sources via various protocols and services.

Nix provides built-in fetchers such as [`builtins.fetchTarball`](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-fetchTarball).
Nixpkgs provides its own fetchers, which work differently:

- A built-in fetcher will download and cache files at evaluation time and produce a [store path](https://nixos.org/manual/nix/stable/glossary#gloss-store-path).
  A Nixpkgs fetcher will create a ([fixed-output](https://nixos.org/manual/nix/stable/glossary#gloss-fixed-output-derivation)) [derivation](https://nixos.org/manual/nix/stable/glossary#gloss-derivation), and files are downloaded at build time.
- Built-in fetchers will invalidate their cache after [`tarball-ttl`](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-tarball-ttl) expires, and will require network activity to check if the cache entry is up to date.
  Nixpkgs fetchers only re-download if the specified hash changes or the store object is not available.
- Built-in fetchers do not use [substituters](https://nixos.org/manual/nix/stable/command-ref/conf-file#conf-substituters).
  Derivations produced by Nixpkgs fetchers will use any configured binary cache transparently.

This significantly reduces the time needed to evaluate Nixpkgs, and allows [Hydra](https://nixos.org/hydra) to retain and re-distribute sources used by Nixpkgs in the [public binary cache](https://cache.nixos.org).
For these reasons, Nix's built-in fetchers are not allowed in Nixpkgs.

The following table summarises the differences:

| Fetchers | Download | Output | Cache | Re-download when |
|-|-|-|-|-|
| `builtins.fetch*` | evaluation time | store path | `/nix/store`, `~/.cache/nix` | `tarball-ttl` expires, cache miss in `~/.cache/nix`, output store object not in local store |
| `pkgs.fetch*` | build time | derivation | `/nix/store`, substituters | output store object not available |

:::{.tip}
`pkgs.fetchFrom*` helpers retrieve _snapshots_ of version-controlled sources, as opposed to the entire version history, which is more efficient.
`pkgs.fetchgit` by default also has the same behaviour, but can be changed through specific attributes given to it.
:::

## Caveats {#chap-pkgs-fetchers-caveats}

Because Nixpkgs fetchers are fixed-output derivations, an [output hash](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-outputHash) has to be specified, usually indirectly through a `hash` attribute.
This hash refers to the derivation output, which can be different from the remote source itself!

This has the following implications that you should be aware of:

- Use Nix (or Nix-aware) tooling to produce the output hash.

- When changing any fetcher parameters, always update the output hash.
  Use one of the methods from [](#sec-pkgs-fetchers-updating-source-hashes).
  Otherwise, existing store objects that match the output hash will be re-used rather than fetching new content.

  :::{.note}
  A similar problem arises while testing changes to a fetcher's implementation.
  If the output of the derivation already exists in the Nix store, test failures can go undetected.
  The [`invalidateFetcherByDrvHash`](#tester-invalidateFetcherByDrvHash) function helps prevent reusing cached derivations.
  :::

## Updating source hashes {#sec-pkgs-fetchers-updating-source-hashes}

There are several ways to obtain the hash corresponding to a remote source.
Unless you understand how the fetcher you're using calculates the hash from the downloaded contents, you should use [the fake hash method](#sec-pkgs-fetchers-updating-source-hashes-fakehash-method).

1. []{#sec-pkgs-fetchers-updating-source-hashes-fakehash-method} The fake hash method: In your package recipe, set the hash to one of

   - `""`
   - `lib.fakeHash`
   - `lib.fakeSha256`
   - `lib.fakeSha512`

   Attempt to build, extract the calculated hashes from error messages, and put them into the recipe.

   :::{.warning}
   You must use one of these four fake hashes and not some arbitrarily-chosen hash.
   See [](#sec-pkgs-fetchers-secure-hashes) for details.
   :::

   :::{.example #ex-fetchers-update-fod-hash}
   # Update source hash with the fake hash method

   Consider the following recipe that produces a plain file:

   ```nix
   { fetchurl }:
   fetchurl {
     url = "https://raw.githubusercontent.com/NixOS/nixpkgs/23.05/.version";
     hash = "sha256-ZHl1emidXVojm83LCVrwULpwIzKE/mYwfztVkvpruOM=";
   }
   ```

   A common mistake is to update a fetcher parameter, such as `url`, without updating the hash:

   ```nix
   { fetchurl }:
   fetchurl {
     url = "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version";
     hash = "sha256-ZHl1emidXVojm83LCVrwULpwIzKE/mYwfztVkvpruOM=";
   }
   ```

   **This will produce the same output as before!**
   Set the hash to an empty string:

   ```nix
   { fetchurl }:
   fetchurl {
     url = "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version";
     hash = "";
   }
   ```

   When building the package, use the error message to determine the correct hash:

   ```shell
   $ nix-build
   (some output removed for clarity)
   error: hash mismatch in fixed-output derivation '/nix/store/7yynn53jpc93l76z9zdjj4xdxgynawcw-version.drv':
           specified: sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
               got:    sha256-BZqI7r0MNP29yGH5+yW2tjU9OOpOCEvwWKrWCv5CQ0I=
   error: build of '/nix/store/bqdjcw5ij5ymfbm41dq230chk9hdhqff-version.drv' failed
   ```
   :::

2. Prefetch the source with [`nix-prefetch-<type> <URL>`](https://search.nixos.org/packages?buckets={%22package_attr_set%22%3A[%22No%20package%20set%22]%2C%22package_license_set%22%3A[]%2C%22package_maintainers_set%22%3A[]%2C%22package_platforms%22%3A[]}&query=nix-prefetch), where `<type>` is one of

   - `url`
   - `git`
   - `hg`
   - `cvs`
   - `bzr`
   - `svn`

   The hash is printed to stdout.

3. Prefetch by package source (with `nix-prefetch-url '<nixpkgs>' -A <package>.src`, where `<package>` is package attribute name).
   The hash is printed to stdout.

   This works well when you've upgraded the existing package version and want to find out new hash, but is useless if the package can't be accessed by attribute or the package has multiple sources (`.srcs`, architecture-dependent sources, etc).

4. Upstream hash: use it when upstream provides `sha256` or `sha512`.
   Don't use it when upstream provides `md5`, compute `sha256` instead.

   A little nuance is that `nix-prefetch-*` tools produce hashes with the `nix32` encoding (a Nix-specific base32 adaptation), but upstream usually provides hexadecimal (`base16`) encoding.
   Fetchers understand both formats.
   Nixpkgs does not standardise on any one format.

   You can convert between hash formats with [`nix-hash`](https://nixos.org/manual/nix/stable/command-ref/nix-hash).

5. Extract the hash from a local source archive with `sha256sum`.
   Use `nix-prefetch-url file:///path/to/archive` if you want the custom Nix `base32` hash.

## Obtaining hashes securely {#sec-pkgs-fetchers-secure-hashes}

It's always a good idea to avoid Man-in-the-Middle (MITM) attacks when downloading source contents.
Otherwise, you could unknowingly download malware instead of the intended source, and instead of the actual source hash, you'll end up using the hash of malware.
Here are security considerations for this scenario:

- `http://` URLs are not secure to prefetch hashes.

- Upstream hashes should be obtained via a secure protocol.

- `https://` URLs give you more protections when using `nix-prefetch-*` or for upstream hashes.

- `https://` URLs are secure when using the [fake hash method](#sec-pkgs-fetchers-updating-source-hashes-fakehash-method) *only if* you use one of the listed fake hashes.
  If you use any other hash, the download will be exposed to MITM attacks even if you use HTTPS URLs.

  In more concrete terms, if you use any other hash, the [`--insecure` flag](https://curl.se/docs/manpage.html#-k) will be passed to the underlying call to `curl` when downloading content.

## `fetchurl` and `fetchzip` {#fetchurl}

Two basic fetchers are `fetchurl` and `fetchzip`. Both of these have two required arguments, a URL and a hash. The hash is typically `hash`, although many more hash algorithms are supported. Nixpkgs contributors are currently recommended to use `hash`. This hash will be used by Nix to identify your source. A typical usage of `fetchurl` is provided below.

```nix
{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "hello";
  src = fetchurl {
    url = "http://www.example.org/hello.tar.gz";
    hash = "sha256-BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=";
  };
}
```

The main difference between `fetchurl` and `fetchzip` is in how they store the contents. `fetchurl` will store the unaltered contents of the URL within the Nix store. `fetchzip` on the other hand, will decompress the archive for you, making files and directories directly accessible in the future. `fetchzip` can only be used with archives. Despite the name, `fetchzip` is not limited to .zip files and can also be used with any tarball.

Additional parameters to `fetchurl`:
- `downloadToTemp`: Defaults to `false`. If `true`, saves the source to `$downloadedFile`, to be used in conjunction with `postFetch`
- `postFetch`: Shell code executed after the file has been fetched successfully. Use it for postprocessing, to check or transform the file.

## `fetchpatch` {#fetchpatch}

`fetchpatch` works very similarly to `fetchurl` with the same arguments expected. It expects patch files as a source and performs normalization on them before computing the checksum. For example, it will remove comments or other unstable parts that are sometimes added by version control systems and can change over time.

- `relative`: Similar to using `git-diff`'s `--relative` flag, only keep changes inside the specified directory, making paths relative to it.
- `stripLen`: Remove the first `stripLen` components of pathnames in the patch.
- `decode`: Pipe the downloaded data through this command before processing it as a patch.
- `extraPrefix`: Prefix pathnames by this string.
- `excludes`: Exclude files matching these patterns (applies after the above arguments).
- `includes`: Include only files matching these patterns (applies after the above arguments).
- `revert`: Revert the patch.

Note that because the checksum is computed after applying these effects, using or modifying these arguments will have no effect unless the `hash` argument is changed as well.


Most other fetchers return a directory rather than a single file.


## `fetchDebianPatch` {#fetchdebianpatch}

A wrapper around `fetchpatch`, which takes:
- `patch` and `hash`: the patch's filename,
  and its hash after normalization by `fetchpatch` ;
- `pname`: the Debian source package's name ;
- `version`: the upstream version number ;
- `debianRevision`: the [Debian revision number] if applicable ;
- the `area` of the Debian archive: `main` (default), `contrib`, or `non-free`.

Here is an example of `fetchDebianPatch` in action:

```nix
{ lib
, fetchDebianPatch
, buildPythonPackage
}:

buildPythonPackage rec {
  pname = "pysimplesoap";
  version = "1.16.2";
  src = <...>;

  patches = [
    (fetchDebianPatch {
      inherit pname version;
      debianRevision = "5";
      name = "Add-quotes-to-SOAPAction-header-in-SoapClient.patch";
      hash = "sha256-xA8Wnrpr31H8wy3zHSNfezFNjUJt1HbSXn3qUMzeKc0=";
    })
  ];

  # ...
}
```

Patches are fetched from `sources.debian.org`, and so must come from a
package version that was uploaded to the Debian archive.  Packages may
be removed from there once that specific version isn't in any suite
anymore (stable, testing, unstable, etc.), so maintainers should use
`copy-tarballs.pl` to archive the patch if it needs to be available
longer-term.

[Debian revision number]: https://www.debian.org/doc/debian-policy/ch-controlfields.html#version


## `fetchsvn` {#fetchsvn}

Used with Subversion. Expects `url` to a Subversion directory, `rev`, and `hash`.

## `fetchgit` {#fetchgit}

Used with Git. Expects `url` to a Git repo, `rev`, and `hash`. `rev` in this case can be full the git commit id (SHA1 hash) or a tag name like `refs/tags/v1.0`.

Additionally, the following optional arguments can be given: `fetchSubmodules = true` makes `fetchgit` also fetch the submodules of a repository. If `deepClone` is set to true, the entire repository is cloned as opposing to just creating a shallow clone. `deepClone = true` also implies `leaveDotGit = true` which means that the `.git` directory of the clone won't be removed after checkout.

If only parts of the repository are needed, `sparseCheckout` can be used. This will prevent git from fetching unnecessary blobs from server, see [git sparse-checkout](https://git-scm.com/docs/git-sparse-checkout) for more information:

```nix
{ stdenv, fetchgit }:

stdenv.mkDerivation {
  name = "hello";
  src = fetchgit {
    url = "https://...";
    sparseCheckout = [
      "directory/to/be/included"
      "another/directory"
    ];
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };
}
```

## `fetchfossil` {#fetchfossil}

Used with Fossil. Expects `url` to a Fossil archive, `rev`, and `hash`.

## `fetchcvs` {#fetchcvs}

Used with CVS. Expects `cvsRoot`, `tag`, and `hash`.

## `fetchhg` {#fetchhg}

Used with Mercurial. Expects `url`, `rev`, and `hash`.

A number of fetcher functions wrap part of `fetchurl` and `fetchzip`. They are mainly convenience functions intended for commonly used destinations of source code in Nixpkgs. These wrapper fetchers are listed below.

## `fetchFromGitea` {#fetchfromgitea}

`fetchFromGitea` expects five arguments. `domain` is the gitea server name. `owner` is a string corresponding to the Gitea user or organization that controls this repository. `repo` corresponds to the name of the software repository. These are located at the top of every Gitea HTML page as `owner`/`repo`. `rev` corresponds to the Git commit hash or tag (e.g `v1.0`) that will be downloaded from Git. Finally, `hash` corresponds to the hash of the extracted directory. Again, other hash algorithms are also available but `hash` is currently preferred.

## `fetchFromGitHub` {#fetchfromgithub}

`fetchFromGitHub` expects four arguments. `owner` is a string corresponding to the GitHub user or organization that controls this repository. `repo` corresponds to the name of the software repository. These are located at the top of every GitHub HTML page as `owner`/`repo`. `rev` corresponds to the Git commit hash or tag (e.g `v1.0`) that will be downloaded from Git. Finally, `hash` corresponds to the hash of the extracted directory. Again, other hash algorithms are also available, but `hash` is currently preferred.

To use a different GitHub instance, use `githubBase` (defaults to `"github.com"`).

`fetchFromGitHub` uses `fetchzip` to download the source archive generated by GitHub for the specified revision. If `leaveDotGit`, `deepClone` or `fetchSubmodules` are set to `true`, `fetchFromGitHub` will use `fetchgit` instead. Refer to its section for documentation of these options.

## `fetchFromGitLab` {#fetchfromgitlab}

This is used with GitLab repositories. It behaves similarly to `fetchFromGitHub`, and expects `owner`, `repo`, `rev`, and `hash`.

To use a specific GitLab instance, use `domain` (defaults to `"gitlab.com"`).


## `fetchFromGitiles` {#fetchfromgitiles}

This is used with Gitiles repositories. The arguments expected are similar to `fetchgit`.

## `fetchFromBitbucket` {#fetchfrombitbucket}

This is used with BitBucket repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromSavannah` {#fetchfromsavannah}

This is used with Savannah repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromRepoOrCz` {#fetchfromrepoorcz}

This is used with repo.or.cz repositories. The arguments expected are very similar to `fetchFromGitHub` above.

## `fetchFromSourcehut` {#fetchfromsourcehut}

This is used with sourcehut repositories. Similar to `fetchFromGitHub` above,
it expects `owner`, `repo`, `rev` and `hash`, but don't forget the tilde (~)
in front of the username! Expected arguments also include `vc` ("git" (default)
or "hg"), `domain` and `fetchSubmodules`.

If `fetchSubmodules` is `true`, `fetchFromSourcehut` uses `fetchgit`
or `fetchhg` with `fetchSubmodules` or `fetchSubrepos` set to `true`,
respectively. Otherwise, the fetcher uses `fetchzip`.

## `requireFile` {#requirefile}

`requireFile` allows requesting files that cannot be fetched automatically, but whose content is known.
This is a useful last-resort workaround for license restrictions that prohibit redistribution, or for downloads that are only accessible after authenticating interactively in a browser.
If the requested file is present in the Nix store, the resulting derivation will not be built, because its expected output is already available.
Otherwise, the builder will run, but fail with a message explaining to the user how to provide the file. The following code, for example:

```nix
requireFile {
  name = "jdk-${version}_linux-x64_bin.tar.gz";
  url = "https://www.oracle.com/java/technologies/javase-jdk11-downloads.html";
  hash = "sha256-lL00+F7jjT71nlKJ7HRQuUQ7kkxVYlZh//5msD8sjeI=";
}
```
results in this error message:
```
***
Unfortunately, we cannot download file jdk-11.0.10_linux-x64_bin.tar.gz automatically.
Please go to https://www.oracle.com/java/technologies/javase-jdk11-downloads.html to download it yourself, and add it to the Nix store
using either
  nix-store --add-fixed sha256 jdk-11.0.10_linux-x64_bin.tar.gz
or
  nix-prefetch-url --type sha256 file:///path/to/jdk-11.0.10_linux-x64_bin.tar.gz

***
```

This function should only be used by non-redistributable software with an unfree license that we need to require the user to download manually.
It produces packages that cannot be built automatically.

## `fetchtorrent` {#fetchtorrent}

`fetchtorrent` expects two arguments. `url` which can either be a Magnet URI (Magnet Link) such as `magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c` or an HTTP URL pointing to a `.torrent` file. It can also take a `config` argument which will craft a `settings.json` configuration file and give it to `transmission`, the underlying program that is performing the fetch. The available config options for `transmission` can be found [here](https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md#options)

```nix
{ fetchtorrent }:

fetchtorrent {
  config = { peer-limit-global = 100; };
  url = "magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c";
  sha256 = "";
}
```

### Parameters {#fetchtorrent-parameters}

- `url`: Magnet URI (Magnet Link) such as `magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c` or an HTTP URL pointing to a `.torrent` file.

- `backend`: Which bittorrent program to use. Default: `"transmission"`. Valid values are `"rqbit"` or `"transmission"`. These are the two most suitable torrent clients for fetching in a fixed-output derivation at the time of writing, as they can be easily exited after usage. `rqbit` is written in Rust and has a smaller closure size than `transmission`, and the performance and peer discovery properties differs between these clients, requiring experimentation to decide upon which is the best.

- `config`: When using `transmission` as the `backend`, a json configuration can
  be supplied to transmission. Refer to the [upstream documentation](https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md) for information on how to configure.

