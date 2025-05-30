{
  lib,
  buildNimSbom,
  fetchFromGitea,
}:

buildNimSbom (finalAttrs: {
  src = fetchFromGitea {
    domain = "git.syndicate-lang.org";
    owner = "ehmry";
    repo = "preserves-nim";
    rev = finalAttrs.version;
    hash = "sha256-A1v72ToSLEEUZTNcPl82t8OKvr5heQCWVWYEJh362Eo=";
  };

  # Tests requires balls which is not listed in the lockfilee.
  doCheck = false;

  postInstall = ''
    pushd $out/bin
    for link in preserves-decode \
        preserves-from-json preserves-to-json \
        preserves-from-xml preserves-to-xml
      do ln -s preserves-encode $link
    done
    popd
  '';

  meta = {
    description = "Utilities for working with Preserves documents and schemas";
    license = lib.licenses.unlicense;
    homepage = "https://git.syndicate-lang.org/ehmry/preserves-nim";
    maintainers = with lib.maintainers; [ ehmry ];
  };
}) ./sbom.json
