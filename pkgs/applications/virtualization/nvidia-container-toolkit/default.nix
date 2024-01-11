{ lib
, stdenv
, glibc
, fetchFromGitLab
, makeWrapper
, buildGoModule
, linkFarm
, writeShellScript
, fetchpatch2
, formats
, containerRuntimePath
, configTemplate
, configTemplatePath ? null
, libnvidia-container
, cudaPackages
}:

assert configTemplate != null -> (lib.isAttrs configTemplate && configTemplatePath == null);
assert configTemplatePath != null -> (lib.isStringLike configTemplatePath && configTemplate == null);

let
  isolatedContainerRuntimePath = linkFarm "isolated_container_runtime_path" [
    {
      name = "runc";
      path = containerRuntimePath;
    }
  ];
  warnIfXdgConfigHomeIsSet = writeShellScript "warn_if_xdg_config_home_is_set" ''
    set -eo pipefail

    if [ -n "$XDG_CONFIG_HOME" ]; then
      echo >&2 "$(tput setaf 3)warning: \$XDG_CONFIG_HOME=$XDG_CONFIG_HOME$(tput sgr 0)"
    fi
  '';

  configToml = if configTemplatePath != null then configTemplatePath else (formats.toml { }).generate "config.toml" configTemplate;

  # From https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/6f3d9307bbde56cb4f0be92ea7246e183e98dda6/Makefile#L54
  cliVersionPackage = "github.com/NVIDIA/nvidia-container-toolkit/internal/info";
in
buildGoModule rec {
  pname = "container-toolkit/container-toolkit";
  version = "unstable-2024-01-22";

  src = fetchFromGitLab {
    owner = "nvidia";
    repo = pname;
    rev = "b3519fadc469229e920766c4be7fad0fb955fd35";
    hash = "sha256-tGZB3gj4OQtxKOqSVvuZo33iVPW5BtvMLir+Ixr1bq0=";
  };

  vendorHash = null;

  patches = [
    (fetchpatch2 {
      name = "0001-Add-dlopen-discoverer.patch";
      url = "https://gitlab.com/jmbaur/container-toolkit/commit/e4449f06a8989ff22947309151855b388c311aed.patch";
      hash = "sha256-0rfyJNoLSXxEvXfRemgoZba0gONZVJYy0c4JRtMsGVw=";
    })
  ];

  ldflags = [ "-s" "-w" "-extldflags=-Wl,-z,lazy" "-X" "${cliVersionPackage}.version=${version}" ];

  nativeBuildInputs = [ makeWrapper ] ++ lib.optional stdenv.isx86_64 cudaPackages.autoAddOpenGLRunpathHook ;

  preConfigure = ''
    # Ensure the runc symlink isn't broken:
    if ! readlink --quiet --canonicalize-existing "${isolatedContainerRuntimePath}/runc" ; then
      echo "${isolatedContainerRuntimePath}/runc: broken symlink" >&2
      exit 1
    fi
  '';

  checkFlags =
    let
      skippedTests = [
        # Disable tests executing nvidia-container-runtime command.
        "TestGoodInput"
        "TestDuplicateHook"
      ];
    in
    [ "-skip" "${builtins.concatStringsSep "|" skippedTests}" ];

  postInstall = ''
    mkdir -p $out/etc/nvidia-container-runtime

    # nvidia-container-runtime invokes docker-runc or runc if that isn't
    # available on PATH.
    #
    # Also set XDG_CONFIG_HOME if it isn't already to allow overriding
    # configuration. This in turn allows users to have the nvidia container
    # runtime enabled for any number of higher level runtimes like docker and
    # podman, i.e., there's no need to have mutually exclusivity on what high
    # level runtime can enable the nvidia runtime because each high level
    # runtime has its own config.toml file.
    wrapProgram $out/bin/nvidia-container-runtime \
      --run "${warnIfXdgConfigHomeIsSet}" \
      --prefix PATH : ${isolatedContainerRuntimePath}:${libnvidia-container}/bin \
      --set-default XDG_CONFIG_HOME $out/etc

    cp ${configToml} $out/etc/nvidia-container-runtime/config.toml

    substituteInPlace $out/etc/nvidia-container-runtime/config.toml \
      --subst-var-by glibcbin ${lib.getBin glibc}

    ln -s $out/bin/nvidia-container-{runtime-hook,toolkit}

    wrapProgram $out/bin/nvidia-container-toolkit \
      --add-flags "-config ${placeholder "out"}/etc/nvidia-container-runtime/config.toml"
  '';

  meta = with lib; {
    homepage = "https://gitlab.com/nvidia/container-toolkit/container-toolkit";
    description = "NVIDIA Container Toolkit";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cpcloud ];
  };
}
