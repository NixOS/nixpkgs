{
  callPackage,
  fetchFromGitHub,
  nixos,
  conmon,
}:
let
  apptainer =
    callPackage
      (import ./generic.nix rec {
        pname = "apptainer";
        version = "1.5.3";
        projectName = "apptainer";

        src = fetchFromGitHub {
          owner = "apptainer";
          repo = "apptainer";
          tag = "v${version}";
          hash = "sha256-5irHhLcDCopq/tQ4/9ex9eYE2Qsuzv89QQ0MwO/vJ2w=";
        };

        # Override vendorHash with overrideAttrs.
        # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
        vendorHash = "sha256-9pceK+cUazw6gHiwIb1Su95ByNiOnJATSSuUsJxhHJw=";

        extraDescription = " (previously known as Singularity)";
        extraMeta.homepage = "https://apptainer.org";
      })
      {
        # Apptainer doesn't depend on conmon
        conmon = null;

        # Apptainer builders require explicit --with-suid / --without-suid flag
        # when building on a system with disabled unprivileged namespace.
        # See https://github.com/NixOS/nixpkgs/pull/215690#issuecomment-1426954601
        defaultToSuid = null;

        sourceFilesWithDefaultPaths = {
          "cmd/internal/cli/actions.go" = [ "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin" ];
          "e2e/env/env.go" = [ "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" ];
          "internal/pkg/util/env/env.go" = [ "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" ];
        };
      };

  singularity =
    callPackage
      (import ./generic.nix rec {
        pname = "singularity-ce";
        version = "4.5.0";
        projectName = "singularity";

        src = fetchFromGitHub {
          owner = "sylabs";
          repo = "singularity";
          tag = "v${version}";
          hash = "sha256-jy9frLUAmWC9TxSeDGhgqpSTDdzi8Sr/gUd90pZ9p8M=";
        };

        # Override vendorHash with overrideAttrs.
        # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
        vendorHash = "sha256-Ad2C1BpFFIXeooyPNlxodjFhrggi17UXQTV1CNXZt8k=";

        extraConfigureFlags = [
          # Do not build squashfuse from the Git submodule sources, use Nixpkgs provided version
          "--without-squashfuse"
          # Disable subid as it requires (unavailable?) libsubid headers:
          "--without-libsubid"
        ];

        extraDescription = " (Sylabs Inc's fork of Singularity, a.k.a. SingularityCE)";
        extraMeta.homepage = "https://sylabs.io/";
      })
      {
        # Sylabs SingularityCE builders defaults to set the SUID flag
        # on UNIX-like platforms,
        # and only have --without-suid but not --with-suid.
        defaultToSuid = true;

        sourceFilesWithDefaultPaths = {
          "cmd/internal/cli/actions.go" = [ "/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin" ];
          "e2e/env/env.go" = [ "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" ];
          "internal/pkg/util/env/clean.go" = [
            "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          ];
          # Since 4.5.0, SingularityCE locates helper binaries (mksquashfs,
          # unsquashfs, ...) via the "root search path" / "user search path"
          # directives instead of $PATH, so the wrapped PATH is ignored.
          # Inject the Nixpkgs binary paths into their defaults.
          "pkg/util/singularityconf/config.go" = [
            "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          ];
        };
      };

  genOverridenNixos =
    package: packageName:
    (nixos {
      programs.singularity = {
        enable = true;
        inherit package;
      };
    }).config.programs.singularity.packageOverriden.overrideAttrs
      (oldAttrs: {
        meta = oldAttrs.meta // {
          description = "";
          longDescription = ''
            This package produces identical store derivations to `pkgs.${packageName}`
            overridden and installed by the NixOS module `programs.singularity`
            with default configuration.

            This is for binary substitutes only. Use pkgs.${packageName} instead.
          '';
        };
      });
in
{
  inherit apptainer singularity;

  apptainer-overriden-nixos = genOverridenNixos apptainer "apptainer";
  singularity-overriden-nixos = genOverridenNixos singularity "singularity";
}
