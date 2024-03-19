{ lib
, glibc
, fetchFromGitLab
, makeWrapper
, buildGoModule
, linkFarm
, writeShellScript
, formats
, containerRuntimePath ? null
, configTemplate ? null
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

  # From https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L54
  cliVersionPackage = "github.com/NVIDIA/nvidia-container-toolkit/internal/info";
in
buildGoModule rec {
  pname = "container-toolkit/container-toolkit";
  version = "1.15.0-rc.3";

  src = fetchFromGitLab {
    owner = "nvidia";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-IH2OjaLbcKSGG44aggolAOuJkjk+GaXnnTbrXfZ0lVo=";

  };

  vendorHash = null;

  patches = [
    # This patch causes library lookups to first attempt loading via dlopen
    # before falling back to the regular symlink location and ldcache location.
    ./0001-Add-dlopen-discoverer.patch
  ];

  postPatch = ''
    # Replace the default hookDefaultFilePath to the $out path and override
    # default ldconfig locations to the one in nixpkgs.

    substituteInPlace internal/config/config.go \
      --replace '/usr/bin/nvidia-container-runtime-hook' "$out/bin/nvidia-container-runtime-hook" \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace internal/config/config_test.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace tools/container/toolkit/toolkit.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'

    substituteInPlace cmd/nvidia-ctk/hook/update-ldcache/update-ldcache.go \
      --replace '/sbin/ldconfig' '${lib.getBin glibc}/sbin/ldconfig'
  '';

  # Based on upstream's Makefile:
  # https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/Makefile#L64
  ldflags = [
    "-extldflags=-Wl,-z,lazy" # May be redunandant, cf. `man ld`: "Lazy binding is the default".
    "-s" # "disable symbol table"
    "-w" # "disable DWARF generation"

    # "-X name=value"
    "-X"
    "${cliVersionPackage}.version=${version}"
  ];

  nativeBuildInputs = [
    cudaPackages.autoAddDriverRunpath
    makeWrapper
  ];

  preConfigure = lib.optionalString (containerRuntimePath != null) ''
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

  postInstall = lib.optionalString (containerRuntimePath != null) ''
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

    # See: https://gitlab.com/nvidia/container-toolkit/container-toolkit/-/blob/03cbf9c6cd26c75afef8a2dd68e0306aace80401/packaging/debian/nvidia-container-toolkit.postinst#L12
    ln -s $out/bin/nvidia-container-runtime-hook $out/bin/nvidia-container-toolkit

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
