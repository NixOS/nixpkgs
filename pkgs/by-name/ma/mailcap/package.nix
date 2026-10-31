{
  lib,
  stdenv,
  fetchFromGitHub,
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

  src = fetchFromGitHub {
    owner = "InfrastructureServices";
    repo = "mailcap";
    rev = "r${lib.replaceString "." "-" finalAttrs.version}";
    hash = "sha256-tiyYiYKSB4UJRh+OZOvBDSF/VDyIIFA95H63qxFyc5g=";
  };

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    substituteInPlace mailcap --replace-fail "/usr/bin/" ""
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
    VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/InfrastructureServices/mailcap | \
      awk '{ print $2 }' | \
      grep "refs/tags/r" | \
      sed -E -e "s,refs/tags/r(.*)$,\1," -e "s/-/./g" | \
      sort --version-sort --reverse | \
      head -n1)"
    exec nix-update --version "$VERSION" "$@"
  '';

  passthru.tests.nginx-mime = nixosTests.nginx.mainline.mime;

  __structuredAttrs = true;

  meta = {
    description = "Helper application and MIME type associations for file types";
    homepage = "https://github.com/InfrastructureServices/mailcap";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
