{
  lib,
  stdenv,
  fetchurl,
  nixosTests,

  # updater
  git,
  coreutils,
  gawk,
  gnused,
  writeScript,
  nix-update,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mailcap";
  version = "2.1.54";

  src = fetchurl {
    url = "https://releases.pagure.org/mailcap/mailcap-${finalAttrs.version}.tar.xz";
    hash = "sha256-mkAyIC/A0rCFj0GxZzianP5SrCTsKC5kebkHZTGd4RM=";
  };

  installPhase = ''
    runHook preInstall

    substituteInPlace mailcap --replace "/usr/bin/" ""
    sh generate-nginx-mimetypes.sh < mime.types > nginx-mime.types

    install -D -m0644 nginx-mime.types $out/etc/nginx/mime.types
    install -D -m0644 -t $out/etc mailcap mime.types
    install -D -m0644 -t $out/share/man/man5 mailcap.5

    runHook postInstall
  '';

  passthru.updateScript = writeScript "update-mailcap" ''
    export PATH=${
      lib.makeBinPath [
        git
        coreutils
        gawk
        gnused
        nix-update
      ]
    }:$PATH
    VERSION="$(git ls-remote --tags --sort="v:refname" https://pagure.io/mailcap.git | \
      awk '{ print $2 }' | \
      grep "refs/tags/r" | \
      sed -E -e "s,refs/tags/r(.*)$,\1," -e "s/-/./g" | \
      sort --version-sort --reverse | \
      head -n1)"
    exec nix-update --version "$VERSION" "$@"
  '';

  passthru.tests.nginx-mime = nixosTests.nginx-mime;

  meta = {
    description = "Helper application and MIME type associations for file types";
    homepage = "https://pagure.io/mailcap";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ c0bw3b ];
    platforms = lib.platforms.all;
  };
})
