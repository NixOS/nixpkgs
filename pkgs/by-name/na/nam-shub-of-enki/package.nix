{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  emacs,
  emacsPackagesFor,
  iocaine,
  just,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "nam-shub-of-enki";
  version = "0-unstable-2026-08-16";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "nam-shub-of-enki";
    rev = "951fd3d6f9700bc87639f82551d0c2c1e6b7e8b3";
    hash = "sha256-cJkmtIsSz/pxNkqgjUUjfbUcxZ9OV2EIRKpukEC8sFc=";
  };

  nativeBuildInputs =
    let
      emacs' = (emacsPackagesFor emacs).emacsWithPackages (
        epkgs:
        (with epkgs; [
          org-roam
          ox-hugo
          projectile
        ])
      );
    in
    [
      just
      emacs'
    ];

  nativeCheckInputs = [
    iocaine
  ];

  doCheck = true;

  buildPhase = "just build code";

  checkPhase = "just build tests";

  installPhase = ''
    mkdir -p $out
    cp -prd out/* $out/
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Bot detection and classification module for Iocaine";
    longDescription = ''
      This package provides a `nam-shub-of-enki` request handler for use with `pkgs.iocaine`.

      On NixOS, this module be used with the following configuration:
      ```nix
      {
        services.iocaine.settings.handler.nam-shub-of-enki = {
          path = pkgs.nam-shub-of-enki;
          language = "roto";
        };
      }
      ```

      Additional configuration is needed for a working module. See the [upstream documentation](https://3.nam-shub-of-enki.iocaine.madhouse-project.org).
    '';
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmasquadron ];
    inherit (iocaine.meta) platforms;
    homepage = "https://git.madhouse-project.org/iocaine/nam-shub-of-enki";
  };
}
