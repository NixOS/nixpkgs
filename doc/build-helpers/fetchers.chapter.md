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

## Proxy usage {#sec-pkgs-fetchers-proxy}

Nixpkgs fetchers can make use of a http(s) proxy. Each fetcher will automatically inherit proxy-related environment variables (`http_proxy`, `https_proxy`, etc) via [impureEnvVars](https://nixos.org/manual/nix/stable/language/advanced-attributes#adv-attr-impureEnvVars).

The environment variable `NIX_SSL_CERT_FILE` is also inherited in fetchers, and can be used to provide a custom certificate bundle to fetchers. This is usually required for a https proxy to work without certificate validation errors.

[]{#fetchurl}
## `fetchurl` {#sec-pkgs-fetchers-fetchurl}

`fetchurl` returns a [fixed-output derivation](https://nixos.org/manual/nix/stable/glossary.html#gloss-fixed-output-derivation) which downloads content from a given URL and stores the unaltered contents within the Nix store.

It uses {manpage}`curl(1)` internally, and allows its behaviour to be modified by specifying a few attributes in the argument to `fetchurl` (see the documentation for attributes `curlOpts`, `curlOptsList`, and `netrcPhase`).

The resulting [store path](https://nixos.org/manual/nix/stable/store/store-path) is determined by the hash given to `fetchurl`, and also the `name` (or `pname` and `version`) values.

If neither `name` nor `pname` and `version` are specified when calling `fetchurl`, it will default to using the [basename](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-baseNameOf) of `url` or the first element of `urls`.
If `pname` and `version` are specified, `fetchurl` will use those values and will ignore `name`, even if it is also specified.

### Inputs {#sec-pkgs-fetchers-fetchurl-inputs}

`fetchurl` requires an attribute set with the following attributes:

`url` (String; _optional_)
: The URL to download from.

  :::{.note}
  Either `url` or `urls` must be specified, but not both.
  :::

  All URLs of the format [specified here](https://curl.se/docs/url-syntax.html#rfc-3986-plus) are supported.

  _Default value:_ `""`.

`urls` (List of String; _optional_)
: A list of URLs, specifying download locations for the same content.
  Each URL will be tried in order until one of them succeeds with some content or all of them fail.
  See [](#ex-fetchers-fetchurl-nixpkgs-version-multiple-urls) to understand how this attribute affects the behaviour of `fetchurl`.

  :::{.note}
  Either `url` or `urls` must be specified, but not both.
  :::

  _Default value:_ `[]`.

`hash` (String; _optional_)
: Hash of the derivation output of `fetchurl`, following the format for integrity metadata as defined by [SRI](https://www.w3.org/TR/SRI/).
  For more information, see [](#chap-pkgs-fetchers-caveats).

  :::{.note}
  It is recommended that you use the `hash` attribute instead of the other hash-specific attributes that exist for backwards compatibility.

  If `hash` is not specified, you must specify `outputHash` and `outputHashAlgo`, or one of `sha512`, `sha256`, or `sha1`.
  :::

  _Default value:_ `""`.

`outputHash` (String; _optional_)
: Hash of the derivation output of `fetchurl` in the format expected by Nix.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHash) for more information about its format.

  :::{.note}
  It is recommended that you use the `hash` attribute instead.

  If `outputHash` is specified, you must also specify `outputHashAlgo`.
  :::

  _Default value:_ `""`.

`outputHashAlgo` (String; _optional_)
: Algorithm used to generate the value specified in `outputHash`.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHashAlgo) for more information about the values it supports.

  :::{.note}
  It is recommended that you use the `hash` attribute instead.

  The value specified in `outputHashAlgo` will be ignored if `outputHash` isn't also specified.
  :::

  _Default value:_ `""`.

`sha1` (String; _optional_)
: SHA-1 hash of the derivation output of `fetchurl` in the format expected by Nix.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHash) for more information about its format.

  :::{.note}
  It is recommended that you use the `hash` attribute instead.
  :::

  _Default value:_ `""`.

`sha256` (String; _optional_)
: SHA-256 hash of the derivation output of `fetchurl` in the format expected by Nix.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHash) for more information about its format.

  :::{.note}
  It is recommended that you use the `hash` attribute instead.
  :::

  _Default value:_ `""`.

`sha512` (String; _optional_)
: SHA-512 hash of the derivation output of `fetchurl` in the format expected by Nix.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHash) for more information about its format.

  :::{.note}
  It is recommended that you use the `hash` attribute instead.
  :::

  _Default value:_ `""`.

`name` (String; _optional_)
: The symbolic name of the downloaded file when saved in the Nix store.
  See [the `fetchurl` overview](#sec-pkgs-fetchers-fetchurl) for details on how the name of the file is decided.

  _Default value:_ `""`.

`pname` (String; _optional_)
: A base name, which will be combined with `version` to form the symbolic name of the downloaded file when saved in the Nix store.
  See [the `fetchurl` overview](#sec-pkgs-fetchers-fetchurl) for details on how the name of the file is decided.

  :::{.note}
  If `pname` is specified, you must also specify `version`, otherwise `fetchurl` will ignore the value of `pname`.
  :::

  _Default value:_ `""`.

`version` (String; _optional_)
: A version, which will be combined with `pname` to form the symbolic name of the downloaded file when saved in the Nix store.
  See [the `fetchurl` overview](#sec-pkgs-fetchers-fetchurl) for details on how the name of the file is decided.

  _Default value:_ `""`.

`recursiveHash` (Boolean; _optional_) []{#sec-pkgs-fetchers-fetchurl-inputs-recursiveHash}
: If set to `true`, will signal to Nix that the hash given to `fetchurl` was calculated using the `"recursive"` mode.
  See [the documentation on the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-outputHashMode) for more information about the existing modes.

  By default, `fetchurl` uses `"recursive"` mode when the `executable` attribute is set to `true`, so you don't need to specify `recursiveHash` in this case.

  _Default value:_ `false`.

`executable` (Boolean; _optional_)
: If `true`, sets the executable bit on the downloaded file.

  _Default value_: `false`.

`downloadToTemp` (Boolean; _optional_) []{#sec-pkgs-fetchers-fetchurl-inputs-downloadToTemp}
: If `true`, saves the downloaded file to a temporary location instead of the expected Nix store location.
  This is useful when used in conjunction with `postFetch` attribute, otherwise `fetchurl` will not produce any meaningful output.

  The location of the downloaded file will be set in the `$downloadedFile` variable, which should be used by the script in the `postFetch` attribute.
  See [](#ex-fetchers-fetchurl-nixpkgs-version-postfetch) to understand how to work with this attribute.

  _Default value:_ `false`.

`postFetch` (String; _optional_)
: Script executed after the file has been downloaded successfully, and before `fetchurl` finishes running.
  Useful for post-processing, to check or transform the file in some way.
  See [](#ex-fetchers-fetchurl-nixpkgs-version-postfetch) to understand how to work with this attribute.

  _Default value:_ `""`.

`netrcPhase` (String or Null; _optional_)
: Script executed to create a {manpage}`netrc(5)` file to be used with {manpage}`curl(1)`.
  The script should create the `netrc` file (note that it does not begin with a ".") in the directory it's currently running in (`$PWD`).

  The script is executed during the setup done by `fetchurl` before it runs any of its code to download the specified content.

  :::{.note}
  If specified, `fetchurl` will automatically alter its invocation of {manpage}`curl(1)` to use the `netrc` file, so you don't need to add anything to `curlOpts` or `curlOptsList`.
  :::

  :::{.caution}
  Since `netrcPhase` needs to be specified in your source Nix code, any secrets that you put directly in it will be world-readable by design (both in your source code, and when the derivation gets created in the Nix store).

  If you want to avoid this behaviour, see the documentation of `netrcImpureEnvVars` for an alternative way of dealing with these secrets.
  :::

  _Default value_: `null`.

`netrcImpureEnvVars` (List of String; _optional_)
: If specified, `fetchurl` will add these environment variable names to the list of [impure environment variables](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-impureEnvVars), which will be passed from the environment of the calling user to the builder running the `fetchurl` code.

  This is useful when used with `netrcPhase` to hide any secrets that are used in it, because the script in `netrcPhase` only needs to reference the environment variables with the secrets in them instead.
  However, note that these are called _impure_ variables for a reason:
  the environment that starts the build needs to have these variables declared for everything to work properly, which means that additional setup is required outside what Nix controls.

  _Default value:_ `[]`.

`curlOpts` (String; _optional_)
: If specified, this value will be appended to the invocation of {manpage}`curl(1)` when downloading the URL(s) given to `fetchurl`.
  Multiple arguments can be separated by spaces normally, but values with whitespaces will be interpreted as multiple arguments (instead of a single value), even if the value is escaped.
  See `curlOptsList` for a way to pass values with whitespaces in them.

  _Default value:_ `""`.

`curlOptsList` (List of String; _optional_)
: If specified, each element of this list will be passed as an argument to the invocation of {manpage}`curl(1)` when downloading the URL(s) given to `fetchurl`.
  This allows passing values that contain spaces, with no escaping needed.

  _Default value:_ `[]`.

`showURLs` (Boolean; _optional_)
: If set to `true`, this will stop `fetchurl` from downloading anything at all.
  Instead, it will output a list of all the URLs it would've used to download the content (after resolving `mirror://` URLs, for example).
  This is useful for debugging.

  _Default value:_ `false`.

`meta` (Attribute Set; _optional_)
: Specifies any [meta-attributes](#chap-meta) for the derivation returned by `fetchurl`.

  _Default value:_ `{}`.

`passthru` (Attribute Set; _optional_)
: Specifies any extra [`passthru`](#chap-passthru) attributes for the derivation returned by `fetchurl`.
  Note that `fetchurl` defines [`passthru` attributes of its own](#ssec-pkgs-fetchers-fetchurl-passthru-outputs).
  Attributes specified in `passthru` can override the default attributes returned by `fetchurl`.

  _Default value:_ `{}`.

`preferLocalBuild` (Boolean; _optional_)
: This is the same attribute as [defined in the Nix manual](https://nixos.org/manual/nix/stable/language/advanced-attributes.html#adv-attr-preferLocalBuild).
  It is `true` by default because making a remote machine download the content just duplicates network traffic (since the local machine might download the results from the derivation anyway), but this could be useful in cases where network access is restricted on local machines.

  _Default value:_ `true`.

`nativeBuildInputs` (List of Attribute Set; _optional_)
: Additional packages needed to download the content.
  This is useful if you need extra packages for `postFetch` or `netrcPhase`, for example.
  Has the same semantics as in [](#var-stdenv-nativeBuildInputs).
  See [](#ex-fetchers-fetchurl-nixpkgs-version-postfetch) to understand how this can be used with `postFetch`.

  _Default value:_ `[]`.

### Passthru outputs {#ssec-pkgs-fetchers-fetchurl-passthru-outputs}

`fetchurl` also defines its own [`passthru`](#chap-passthru) attributes:

`url` (String)

: The same `url` attribute passed in the argument to `fetchurl`.

### Examples {#ssec-pkgs-fetchers-fetchurl-examples}

:::{.example #ex-fetchers-fetchurl-nixpkgs-version}
# Using `fetchurl` to download a file

The following package downloads a small file from a URL and shows the most common way to use `fetchurl`:

```nix
{ fetchurl }:
fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version";
  hash = "sha256-BZqI7r0MNP29yGH5+yW2tjU9OOpOCEvwWKrWCv5CQ0I=";
}
```

After building the package, the file will be downloaded and place into the Nix store:

```shell
$ nix-build
(output removed for clarity)
/nix/store/4g9y3x851wqrvim4zcz5x2v3zivmsq8n-version

$ cat /nix/store/4g9y3x851wqrvim4zcz5x2v3zivmsq8n-version
23.11
```
:::

:::{.example #ex-fetchers-fetchurl-nixpkgs-version-multiple-urls}
# Using `fetchurl` to download a file with multiple possible URLs

The following package adapts [](#ex-fetchers-fetchurl-nixpkgs-version) to use multiple URLs.
The first URL was crafted to intentionally return an error to illustrate how `fetchurl` will try multiple URLs until it finds one that works (or all URLs fail).

```nix
{ fetchurl }:
fetchurl {
  urls = [
    "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/does-not-exist"
    "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version"
  ];
  hash = "sha256-BZqI7r0MNP29yGH5+yW2tjU9OOpOCEvwWKrWCv5CQ0I=";
}
```

After building the package, both URLs will be used to download the file:

```shell
$ nix-build
(some output removed for clarity)
trying https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/does-not-exist
(some output removed for clarity)
curl: (22) The requested URL returned error: 404

trying https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version
(some output removed for clarity)
/nix/store/n9asny31z32q7sdw6a8r1gllrsfy53kl-does-not-exist

$ cat /nix/store/n9asny31z32q7sdw6a8r1gllrsfy53kl-does-not-exist
23.11
```

However, note that the name of the file was derived from the first URL (this is further explained in [the `fetchurl` overview](#sec-pkgs-fetchers-fetchurl)).
To ensure the result will have the same name regardless of which URLs are used, we can modify the package:

```nix
{ fetchurl }:
fetchurl {
  name = "nixpkgs-version";
  urls = [
    "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/does-not-exist"
    "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version"
  ];
  hash = "sha256-BZqI7r0MNP29yGH5+yW2tjU9OOpOCEvwWKrWCv5CQ0I=";
}
```

After building the package, the result will have the name we specified:

```shell
$ nix-build
(output removed for clarity)
/nix/store/zczb6wl3al6jm9sm5h3pr6nqn0i5ji9z-nixpkgs-version
```
:::

:::{.example #ex-fetchers-fetchurl-nixpkgs-version-postfetch}
# Manipulating the content downloaded by `fetchurl`

It might be useful to manipulate the content downloaded by `fetchurl` directly in its derivation.
In this example, we'll adapt [](#ex-fetchers-fetchurl-nixpkgs-version) to append the result of running the `hello` package to the contents we download, purely to illustrate how to manipulate the content.

```nix
{ fetchurl, hello, lib }:
fetchurl {
  url = "https://raw.githubusercontent.com/NixOS/nixpkgs/23.11/.version";

  nativeBuildInputs = [ hello ];

  downloadToTemp = true;
  postFetch = ''
    ${lib.getExe hello} >> $downloadedFile
    mv $downloadedFile $out
  '';

  hash = "sha256-ceooQQYmDx5+0nfg40uU3NNI2yKrixP7HZ/xLZUNv+w=";
}
```

After building the package, the resulting file will have "Hello, world!" appended to it:

```shell
$ nix-build
(output removed for clarity)
/nix/store/ifi6pp7q0ag5h7c5v9h1c1c7bhd10c7f-version

$ cat /nix/store/ifi6pp7q0ag5h7c5v9h1c1c7bhd10c7f-version
23.11
Hello, world!
```

Note that the `hash` specified in the package is different than the hash specified in [](#ex-fetchers-fetchurl-nixpkgs-version), because the contents of the output have changed (even though the actual file that was downloaded is the same).
See [](#chap-pkgs-fetchers-caveats) for more details on how to work with the `hash` attribute when the output changes.
:::

## `fetchzip` {#sec-pkgs-fetchers-fetchzip}

Returns a [fixed-output derivation](https://nixos.org/manual/nix/stable/glossary.html#gloss-fixed-output-derivation) which downloads an archive from a given URL and decompresses it.

Despite its name, `fetchzip` is not limited to `.zip` files but can also be used with [various compressed tarball formats](#tar-files) by default.
This can extended by specifying additional attributes, see [](#ex-fetchers-fetchzip-rar-archive) to understand how to do that.

### Inputs {#sec-pkgs-fetchers-fetchzip-inputs}

`fetchzip` requires an attribute set, and most attributes are passed to the underlying call to [`fetchurl`](#sec-pkgs-fetchers-fetchurl).

The attributes below are treated differently by `fetchzip` when compared to what `fetchurl` expects:

`name` (String; _optional_)
: Works as defined in `fetchurl`, but has a different default value than `fetchurl`.

  _Default value:_ `"source"`.

`nativeBuildInputs` (List of Attribute Set; _optional_)
: Works as defined in `fetchurl`, but it is also augmented by `fetchzip` to include packages to deal with additional archives (such as `.zip`).

  _Default value:_ `[]`.

`postFetch` (String; _optional_)
: Works as defined in `fetchurl`, but it is also augmented with the code needed to make `fetchzip` work.

  :::{.caution}
  It is only safe to modify files in `$out` in `postFetch`.
  Consult the implementation of `fetchzip` for anything more involved.
  :::

  _Default value:_ `""`.

`stripRoot` (Boolean; _optional_)
: If `true`, the decompressed contents are moved one level up the directory tree.

  This is useful for archives that decompress into a single directory which commonly includes some values that change with time, such as version numbers.
  When this is the case (and `stripRoot` is `true`), `fetchzip` will remove this directory and make the decompressed contents available in the top-level directory.

  [](#ex-fetchers-fetchzip-simple-striproot) shows what this attribute does.

  This attribute is **not** passed through to `fetchurl`.

  _Default value:_ `true`.

`extension` (String or Null; _optional_)
: If set, the archive downloaded by `fetchzip` will be renamed to a filename with the extension specified in this attribute.

  This is useful when making `fetchzip` support additional types of archives, because the implementation may use the extension of an archive to determine whether they can decompress it.
  If the URL you're using to download the contents doesn't end with the extension associated with the archive, use this attribute to fix the filename of the archive.

  This attribute is **not** passed through to `fetchurl`.

  _Default value:_ `null`.

`recursiveHash` (Boolean; _optional_)
: Works [as defined in `fetchurl`](#sec-pkgs-fetchers-fetchurl-inputs-recursiveHash), but its default value is different than for `fetchurl`.

  _Default value:_ `true`.

`downloadToTemp` (Boolean; _optional_)
: Works [as defined in `fetchurl`](#sec-pkgs-fetchers-fetchurl-inputs-downloadToTemp), but its default value is different than for `fetchurl`.

  _Default value:_ `true`.

`extraPostFetch` **DEPRECATED**
: This attribute is deprecated.
  Please use `postFetch` instead.

  This attribute is **not** passed through to `fetchurl`.

### Examples {#sec-pkgs-fetchers-fetchzip-examples}

::::{.example #ex-fetchers-fetchzip-simple-striproot}
# Using `fetchzip` to output contents directly

The following recipe shows how to use `fetchzip` to decompress a `.tar.gz` archive:

```nix
{ fetchzip }:
fetchzip {
  url = "https://github.com/NixOS/patchelf/releases/download/0.18.0/patchelf-0.18.0.tar.gz";
  hash = "sha256-3ABYlME9R8klcpJ7MQpyFEFwHmxDDEzIYBqu/CpDYmg=";
}
```

This archive has all its contents in a directory named `patchelf-0.18.0`.
This means that after decompressing, you'd have to enter this directory to see the contents of the archive.
However, `fetchzip` makes this easier through the attribute `stripRoot` (enabled by default).

After building the recipe, the derivation output will show all the files in the archive at the top level:

```shell
$ nix-build
(output removed for clarity)
/nix/store/1b7h3fvmgrcddvs0m299hnqxlgli1yjw-source

$ ls /nix/store/1b7h3fvmgrcddvs0m299hnqxlgli1yjw-source
aclocal.m4  completions  configure.ac  m4           Makefile.in  patchelf.spec     README.md  tests
build-aux   configure    COPYING       Makefile.am  patchelf.1   patchelf.spec.in  src        version
```

If `stripRoot` is set to `false`, the derivation output will be the decompressed archive as-is:

```nix
{ fetchzip }:
fetchzip {
  url = "https://github.com/NixOS/patchelf/releases/download/0.18.0/patchelf-0.18.0.tar.gz";
  hash = "sha256-uv3FuKE4DqpHT3yfE0qcnq0gYjDNQNKZEZt2+PUAneg=";
  stripRoot = false;
}
```

:::{.caution}
The hash changed!
Whenever changing attributes of a Nixpkgs fetcher, [remember to invalidate the hash](#chap-pkgs-fetchers-caveats), otherwise you won't get the results you're expecting!
:::

After building the recipe:

```shell
$ nix-build
(output removed for clarity)
/nix/store/2hy5bxw7xgbgxkn0i4x6hjr8w3dbx16c-source

$ ls /nix/store/2hy5bxw7xgbgxkn0i4x6hjr8w3dbx16c-source
patchelf-0.18.0
```
::::

::::{.example #ex-fetchers-fetchzip-rar-archive}
# Using `fetchzip` to decompress a `.rar` file

The `unrar` package provides a [setup hook](#ssec-setup-hooks) to decompress `.rar` archives during the [unpack phase](#ssec-unpack-phase), which can be used with `fetchzip` to decompress those archives:

```nix
{ fetchzip, unrar }:
fetchzip {
  url = "https://archive.org/download/SpaceCadet_Plus95/Space_Cadet.rar";
  hash = "sha256-fC+zsR8BY6vXpUkVd6i1jF0IZZxVKVvNi6VWCKT+pA4=";
  stripRoot = false;
  nativeBuildInputs = [ unrar ];
}
```

Since this particular `.rar` file doesn't put its contents in a directory inside the archive, `stripRoot` must be set to `false`.

After building the recipe, the derivation output will show the decompressed files:

```shell
$ nix-build
(output removed for clarity)
/nix/store/zpn7knxfva6rfjja2gbb4p3l9w1f0d36-source

$ ls /nix/store/zpn7knxfva6rfjja2gbb4p3l9w1f0d36-source
FONT.DAT      PINBALL.DAT  PINBALL.EXE	PINBALL2.MID  TABLE.BMP    WMCONFIG.EXE
MSCREATE.DIR  PINBALL.DOC  PINBALL.MID	Sounds	     WAVEMIX.INF
```
::::

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
  hash = "";
}
```

### Parameters {#fetchtorrent-parameters}

- `url`: Magnet URI (Magnet Link) such as `magnet:?xt=urn:btih:dd8255ecdc7ca55fb0bbf81323d87062db1f6d1c` or an HTTP URL pointing to a `.torrent` file.

- `backend`: Which bittorrent program to use. Default: `"transmission"`. Valid values are `"rqbit"` or `"transmission"`. These are the two most suitable torrent clients for fetching in a fixed-output derivation at the time of writing, as they can be easily exited after usage. `rqbit` is written in Rust and has a smaller closure size than `transmission`, and the performance and peer discovery properties differs between these clients, requiring experimentation to decide upon which is the best.

- `config`: When using `transmission` as the `backend`, a json configuration can
  be supplied to transmission. Refer to the [upstream documentation](https://github.com/transmission/transmission/blob/main/docs/Editing-Configuration-Files.md) for information on how to configure.

