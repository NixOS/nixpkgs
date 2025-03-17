{
  lib,
  stdenvNoCC,
  skopeo,
  dockerTools,
  writeText,
  writeClosure,
  runCommand,
}:

rec {
  /*
    toOCIImage is a generic conversion tool for converting Docker-style tarballs
    into OCI images (directories or tarballs).

    # Inputs
    - `docker-tarball` (drv): The Docker-style tarball to convert. In most cases, this will
      be the output of a `dockerTools.buildImage` call.
    - `name` (string): The name of the resulting OCI image. If not provided, the name of the
      Docker-style tarball will be used (with the `.tar.gz` suffix removed).
    - `outputFormat` (string): The format of the resulting OCI image. Must be one of:
      - `directory`: The output will be an OCI directory.
      - `tarball`: The output will be a tarball of an OCI directory.
  */
  toOCIImage =
    {
      docker-tarball,
      name ? null,
      outputFormat ? "directory",
    }:
    let
      pname =
        if name != null then
          name
        else if lib.hasAttr "name" docker-tarball then
          "${lib.strings.removeSuffix ".tar.gz" docker-tarball.name}-oci"
        else
          throw "name must be provided if the `docker-tarball` input does not have a name attribute";

      skopeoOutputFormats = {
        directory = "oci";
        tarball = "oci-archive";
      };
      skopeoOutputFormat =
        skopeoOutputFormats."${outputFormat}" or throw
          "`outputFormat` must be one of: ${lib.concatStringsSep ", " (lib.attrNames skopeoOutputFormats)}";
    in
    stdenvNoCC.mkDerivation {
      inherit pname;
      src = docker-tarball;
      dontUnpack = true;
      nativeBuildInputs = [ skopeo ];
      buildPhase = ''
        runHook preBuild

        skopeo copy docker-archive:$src ${skopeoOutputFormat}:$out --insecure-policy --tmpdir .

        runHook postBuild
      '';
    };

  # Convenience bindings for drop-in compatibility with `dockerTools`.
  mkDockerToolsDropin =
    target: args:
    toOCIImage {
      docker-tarball = (dockerTools."${target}" args);
    }
    // args.extraOCIArgs or { };

  buildImage = mkDockerToolsDropin "buildImage";
  buildLayeredImage = mkDockerToolsDropin "buildLayeredImage";

  # THE BELOW INTERFACE IS DEPRECATED AND WILL BE REMOVED WITH THE 25.11 RELEASE.
  buildContainer =
    lib.warn
      ''
        `ociTools.buildContainer` is deprecated and will be removed in the 25.11 release.
        Please use `ociTools.buildImage` instead.
      ''
      (
        {
          args,
          mounts ? { },
          os ? "linux",
          arch ? "x86_64",
          readonly ? false,
        }:
        let
          sysMounts = {
            "/proc" = {
              type = "proc";
              source = "proc";
            };
            "/dev" = {
              type = "tmpfs";
              source = "tmpfs";
              options = [
                "nosuid"
                "strictatime"
                "mode=755"
                "size=65536k"
              ];
            };
            "/dev/pts" = {
              type = "devpts";
              source = "devpts";
              options = [
                "nosuid"
                "noexec"
                "newinstance"
                "ptmxmode=0666"
                "mode=755"
                "gid=5"
              ];
            };
            "/dev/shm" = {
              type = "tmpfs";
              source = "shm";
              options = [
                "nosuid"
                "noexec"
                "nodev"
                "mode=1777"
                "size=65536k"
              ];
            };
            "/dev/mqueue" = {
              type = "mqueue";
              source = "mqueue";
              options = [
                "nosuid"
                "noexec"
                "nodev"
              ];
            };
            "/sys" = {
              type = "sysfs";
              source = "sysfs";
              options = [
                "nosuid"
                "noexec"
                "nodev"
                "ro"
              ];
            };
            "/sys/fs/cgroup" = {
              type = "cgroup";
              source = "cgroup";
              options = [
                "nosuid"
                "noexec"
                "nodev"
                "relatime"
                "ro"
              ];
            };
          };
          config = writeText "config.json" (
            builtins.toJSON {
              ociVersion = "1.0.0";
              platform = {
                inherit os arch;
              };

              linux = {
                namespaces = map (type: { inherit type; }) [
                  "pid"
                  "network"
                  "mount"
                  "ipc"
                  "uts"
                ];
              };

              root = {
                path = "rootfs";
                inherit readonly;
              };

              process = {
                inherit args;
                user = {
                  uid = 0;
                  gid = 0;
                };
                cwd = "/";
              };

              mounts = lib.mapAttrsToList (
                destination:
                {
                  type,
                  source,
                  options ? null,
                }:
                {
                  inherit
                    destination
                    type
                    source
                    options
                    ;
                }
              ) sysMounts;
            }
          );
        in
        runCommand "join" { } ''
          set -o pipefail
          mkdir -p $out/rootfs/{dev,proc,sys}
          cp ${config} $out/config.json
          xargs tar c < ${writeClosure args} | tar -xC $out/rootfs/
        ''
      );
}
