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
        version = "1.5.5";
        projectName = "apptainer";

        src = fetchFromGitHub {
          owner = "apptainer";
          repo = "apptainer";
          tag = "v${version}";
          hash = "sha256-oV1LzCBYbMFbKGhli6eCbpMoyB1KeccnaEi+xHJ431g=";
        };

        # Override vendorHash with overrideAttrs.
        # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
        vendorHash = "sha256-k0HhLDImOs+nDn7B3VfxORnWRxTRlefi01YQiaNASeY=";

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
    (callPackage
      (import ./generic.nix rec {
        pname = "singularity-ce";
        version = "4.4.2";
        projectName = "singularity";

        src = fetchFromGitHub {
          owner = "sylabs";
          repo = "singularity";
          tag = "v${version}";
          hash = "sha256-cXWDRpRj8QTdbr7pNz9JeHwAV8gRASHCFq4gXPEbqfg=";
        };

        # Override vendorHash with overrideAttrs.
        # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
        vendorHash = "sha256-4PoFLMkZfYsHpFLn/rfVSqct3LwhLzJ94bVfmHDxPYQ=";

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
          # Since 4.4.2, SingularityCE locates helper binaries (mount,
          # mksquashfs, fusermount, ...) only via the "root search path" and
          # "user search path" directives, no longer via env.DefaultPath.
          # root search path (user search path is handled in postPatch below)
          "pkg/util/singularityconf/config.go" = [
            "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
          ];
        };
      }
    ).overrideAttrs
      (prevAttrs: {
        postPatch =
          prevAttrs.postPatch or ""
          # Inject the Nixpkgs binary paths into the default user search path,
          # after "$PATH" to keep the pre-4.4.2 lookup order.
          + ''
            substituteInPlace pkg/util/singularityconf/config.go \
              --replace-fail \
                '"$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
                "\"\$PATH:$systemDefaultPath''${systemDefaultPath:+:}/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin''${inputsDefaultPath:+:}$inputsDefaultPath\""
          '';
      });

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
            overriden and installed by the NixOS module `programs.singularity`
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
