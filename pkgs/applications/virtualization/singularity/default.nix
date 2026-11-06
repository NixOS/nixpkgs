{
  lib,
  apptainer,
  fetchFromGitHub,
  conmon,
  # Sylabs SingularityCE builders defaults to set the SUID flag
  # on UNIX-like platforms,
  # and only have --without-suid but not --with-suid.
  defaultToSuid ? true,

  sourceFilesWithDefaultPaths ? {
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
  },
  ...
}@deps:

(apptainer.override (
  removeAttrs deps [
    "apptainer"
    "conmon"
  ]
  // {
    inherit
      defaultToSuid
      sourceFilesWithDefaultPaths
      ;
  }
)).overrideAttrs
  (
    finalAttrs: previousAttrs: {
      pname = "singularity-ce";
      version = "4.6.0";

      src = fetchFromGitHub {
        owner = "sylabs";
        repo = "singularity";
        tag = "v${finalAttrs.version}";
        hash = "sha256-fh2MTS44V79AjI9T753TzezbXSnjphNy0CsZXoaJk9A=";
      };

      patches = [ ];

      # Override vendorHash with overrideAttrs.
      # See https://nixos.org/manual/nixpkgs/unstable/#buildGoModule-vendorHash
      vendorHash = "sha256-cx9lIbQKVE2IzeW4GJkhinDYE53e49IZoyu9Fv4WrK0=";

      buildInputs = previousAttrs.buildInputs or [ ] ++ [
        conmon
      ];

      configureFlags = previousAttrs.configureFlags or [ ] ++ [
        # Do not build squashfuse from the Git submodule sources, use Nixpkgs provided version
        "--without-squashfuse"
        # Disable subid as it requires (unavailable?) libsubid headers:
        "--without-libsubid"
      ];

      postPatch =
        previousAttrs.postPatch or ""
        # Inject the Nixpkgs binary paths into the default user search path,
        # after "$PATH" to keep the pre-4.4.2 lookup order.
        + ''
          substituteInPlace pkg/util/singularityconf/config.go \
            --replace-fail \
              '"$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"' \
              "\"\$PATH:$systemDefaultPath''${systemDefaultPath:+:}/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin''${inputsDefaultPath:+:}$inputsDefaultPath\""
        '';

      passthru = previousAttrs.passthru // {
        projectName = "singularity";
      };

      meta = previousAttrs.meta // {
        description =
          previousAttrs.meta.description + " (Sylabs Inc's fork of Singularity, a.k.a. SingularityCE)";
        homepage = "https://sylabs.io/";
        problems = {
          deprecated = {
            message = ''
              Sylabs Inc. has discontinued its development of its fork SingularityCE and the commercial versin SingularityPRO.
              SingularityCE 4.6.0 was the last release, which incorporates code that was previously part of SingularityPRO only.
              Use Apptainer (`apptainer`) instead.
            '';
            urls = [
              "https://sylabs.io/"
            ];
          };
        };
      };
    }
  )
