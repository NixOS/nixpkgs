{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  callPackage,
  emacs,
  emacsPackagesFor,
  iocaine,
  just,
  _experimental-update-script-combinators,
  unstableGitUpdater,
  nix-update-script,
}:

let
  pgpgpg = callPackage ./pgpgpg.nix { };
in

stdenvNoCC.mkDerivation {
  pname = "nam-shub-of-enki";
  version = "0-unstable-2026-11-13";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "git.madhouse-project.org";
    owner = "iocaine";
    repo = "nam-shub-of-enki";
    rev = "860cce14be108a452715a819aea2b691318e48e9";
    hash = "sha256-BPBE1FukoVNE5fCvYS54qMSBvtRvpt3Kuq2L+yOiJPs=";
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
      pgpgpg
    ];

  nativeCheckInputs = [ iocaine ];

  doCheck = true;

  buildPhase = "just build code";

  checkPhase = "just build tests";

  installPhase = ''
    mkdir -p $out
    cp -prd out/* $out/
  '';

  passthru = {
    inherit pgpgpg;
    updateScript = _experimental-update-script-combinators.sequence [
      (unstableGitUpdater { hardcodeZeroVersion = true; })
      (nix-update-script {
        attrPath = "nam-shub-of-enki.pgpgpg";
        extraArgs = [ "--version=branch" ];
      })
    ];
  };

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
