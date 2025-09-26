{
  fetchFromGitLab,
  lib,
  stdenvNoCC,
}:
let
  srcFetchFromGitLab = {
    owner = "trueNAHO";
    repo = "antora-ui-default";
    rev = "11f563294248e9b64124b9289d639e349f2e9f5f";
    hash = "sha256-gUQLLjnWZ1OsAe005IOPIfoM0qmjoevcUuGBRD3oHXA=";
  };
in
stdenvNoCC.mkDerivation {
  pname = "antora-ui-default";
  version = "0-unstable-2024-12-26";

  # The UI bundle is fetched from lib.maintainers.naho's antora-ui-default fork
  # for the following reasons:
  #
  # > The UI bundle is currently unpackaged [1] [2], and only accessible by
  # > fetching the latest GitLab artifact or building from source. Neither
  # > method is reliably reproducible, as artifacts are deleted over time and
  # > building from source requires insecure Node 10.
  # >
  # > The solution is to version control the UI bundle.
  # >
  # > [...]
  # >
  # > [1]: https://gitlab.com/antora/antora-ui-default/-/issues/135
  # > [2]: https://gitlab.com/antora/antora-ui-default/-/issues/211
  # >
  # > -- [3]
  #
  # To avoid bloating the repository archive size, the UI bundle is not stored
  # in Nixpkgs.
  #
  # For reference, the UI bundle from [3] is 300K large.
  #
  # [3]: https://gitlab.com/trueNAHO/antora-ui-default/-/commit/11f563294248e9b64124b9289d639e349f2e9f5f
  src = fetchFromGitLab srcFetchFromGitLab;

  # Install '$src/ui-bundle.zip' to '$out/ui-bundle.zip' instead of '$out' to
  # prevent the ZIP from being misidentified as a binary [1].
  #
  # [1]: https://github.com/NixOS/nixpkgs/blob/8885a1e21ad43f8031c738a08029cd1d4dcbc2f7/pkgs/stdenv/generic/setup.sh#L792-L795
  buildCommand = ''
    mkdir --parents "$out"
    cp "$src/ui-bundle.zip" "$out"
  '';

  meta = {
    description = "Antora default UI bundle";
    homepage = "https://gitlab.com/antora/antora-ui-default";
    license = lib.licenses.mpl20;

    longDescription = ''
      > A UI bundle is a [ZIP
      > archive](https://en.wikipedia.org/wiki/Zip_(file_format)) or directory
      > that contains one or more UIs for a site.
      >
      > -- Antora
      >    https://docs.antora.org/antora/3.1/playbook/ui-bundle-url

      This UI bundle is available under `$out/ui-bundle.zip` and intended to be
      passed to `antora`'s `--ui-bundle-url` flag or injected into the
      [`ui.bundle.url`
      key](https://docs.antora.org/antora/3.1/playbook/ui-bundle-url/#url-key)
      to avoid irreproducible
      [`https://gitlab.com/antora/antora-ui-default/-/jobs/artifacts/HEAD/raw/build/ui-bundle.zip?job=bundle-stable`](https://gitlab.com/${srcFetchFromGitLab.owner}/${srcFetchFromGitLab.repo}/-/blob/${srcFetchFromGitLab.rev}/README.adoc#user-content-use-the-default-ui)
      references.
    '';

    maintainers = [ lib.maintainers.naho ];
    platforms = lib.platforms.all;
  };
}
